--[[
validate.lua: checks one topic against the content contract.

The rules and their codes are in spec/topic-types.md. Each check below is
labeled with the code it enforces, so the two stay in step. If you change a
rule, change it in both places.

Run it through tools/check rather than by hand. tools/check calls Pandoc
like this, one topic at a time:

  pandoc -f markdown-auto_identifiers -t native -o /dev/null \
    --lua-filter tools/validate.lua docs/some-topic.md

It writes no document. It prints each problem to stderr and exits with
status 1 if it found any. (U1, unique IDs across topics, is checked by
tools/check, since it needs every topic at once.)
]]

if PANDOC_VERSION < { 3, 0 } then
  io.stderr:write("tools/validate.lua needs Pandoc 3.0 or later, and this is Pandoc ",
    tostring(PANDOC_VERSION), ". Install Quarto, which includes a current Pandoc.\n")
  os.exit(2)
end

local VOCAB = {
  pair = true, steps = true, prereq = true, result = true,
  note = true, tip = true, warning = true, ["screen-loop"] = true,
}
local VOCAB_LIST = "pair, steps, prereq, result, note, tip, warning, screen-loop"
local TASK_ONLY = { prereq = true, steps = true, result = true }
local TYPES = { concept = true, task = true }

local stringify = pandoc.utils.stringify
local file = (PANDOC_STATE.input_files and PANDOC_STATE.input_files[1]) or "(input)"
local problems = {}
local section = nil   -- nearest heading above the block being checked

-- Report a problem. Pass `here` to add the nearest heading as a location.
local function report(code, msg, here)
  local where = ""
  if here and section then where = string.format(' (under "%s")', section) end
  problems[#problems + 1] = string.format("%s: [%s] %s%s", file, code, msg, where)
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
  return false
end

local function topic_dir()
  return file:match("^(.*)/[^/]*$") or "."
end

-- A src resolves relative to the topic's folder, or to the repo root
-- (where tools/check runs). A leading / means the repo root.
local function src_exists(src)
  if src:sub(1, 1) == "/" then return exists(src:sub(2)) end
  return exists(topic_dir() .. "/" .. src) or exists(src)
end

local function has_class(b, cls)
  return b.t == "Div" and b.classes:includes(cls)
end

-- Is this block only media: a figure, a loop, or a paragraph holding
-- nothing but an image?
local function is_media_block(b)
  if b.t == "Figure" then return true end
  if has_class(b, "screen-loop") then return true end
  if b.t == "Para" or b.t == "Plain" then
    local images, other = 0, 0
    for _, il in ipairs(b.content) do
      if il.t == "Image" then
        images = images + 1
      elseif il.t ~= "Space" and il.t ~= "SoftBreak" and il.t ~= "LineBreak" then
        other = other + 1
      end
    end
    return images > 0 and other == 0
  end
  return false
end

-- Count images and loops anywhere in a list of blocks.
local function media_count(blocks)
  local n = 0
  pandoc.Blocks(blocks):walk {
    Image = function() n = n + 1 end,
    Div = function(d) if d.classes:includes("screen-loop") then n = n + 1 end end,
  }
  return n
end

-- Child block lists of a block, for walking the document.
local function children(b)
  local t = b.t
  if t == "Div" or t == "BlockQuote" or t == "Figure" then
    return { b.content }
  elseif t == "BulletList" or t == "OrderedList" then
    return b.content
  elseif t == "DefinitionList" then
    local out = {}
    for _, item in ipairs(b.content) do
      for _, def in ipairs(item[2]) do out[#out + 1] = def end
    end
    return out
  end
  return {}
end

function Pandoc(doc)
  -- Front matter: F1, F2, F3.
  local function field(name)
    local v = doc.meta[name]
    if v == nil then return nil end
    return trim(stringify(v))
  end

  local id, ttype, desc = field("id"), field("type"), field("description")
  for _, f in ipairs { { "id", id }, { "type", ttype }, { "description", desc } } do
    if f[2] == nil then
      report("F1", string.format("Front matter has no `%s` field.", f[1]))
    elseif f[2] == "" then
      report("F1", string.format("Front matter `%s` is empty.", f[1]))
    end
  end
  if ttype and ttype ~= "" and not TYPES[ttype] then
    report("F2", string.format('`type` is "%s". It must be concept or task.', ttype))
  end
  if id and id ~= "" and not id:match("^[a-z0-9]+[a-z0-9%-]*$") then
    report("F3", string.format('`id` is "%s". Use only lowercase letters, digits, and hyphens.', id))
  end

  local is_task = (ttype == "task")
  local counts = {}       -- task-only block counts
  local positions = {}    -- top-level position of the first of each
  local h1s = {}

  -- Walk the blocks. `parent` is nil at the top level, a block class
  -- inside one of our blocks, or "_" inside anything else.
  local function walk(blocks, parent)
    for i, b in ipairs(blocks) do
      local child_parent = "_"

      if b.t == "Header" then
        section = stringify(b.content)
        if b.level == 1 then h1s[#h1s + 1] = b end
      end

      if b.t == "Div" then
        local cls = nil
        if #b.classes == 0 then
          report("V1", "A ::: block has no class. Give it one of: " .. VOCAB_LIST .. ".", true)
        elseif #b.classes > 1 then
          report("V1", string.format('A ::: block has more than one class (%s). Use one of: %s.',
            table.concat(b.classes, ", "), VOCAB_LIST), true)
        elseif not VOCAB[b.classes[1]] then
          report("V1", string.format('Unknown block "%s". Use one of: %s.', b.classes[1], VOCAB_LIST), true)
        else
          cls = b.classes[1]
        end

        if cls then
          child_parent = cls

          if TASK_ONLY[cls] then
            counts[cls] = (counts[cls] or 0) + 1
            if not is_task then
              report("S3", string.format('A "%s" block is only allowed in a task, and this topic is a %s.',
                cls, ttype or "topic with no type"), true)
            end
            if parent ~= nil then
              report("N1", string.format('The "%s" block is inside another block. Move it to the top level of the topic.', cls), true)
            elseif not positions[cls] then
              positions[cls] = i
            end
          end

          if cls == "steps" then
            local found = false
            pandoc.Blocks(b.content):walk { OrderedList = function() found = true end }
            if not found then
              report("S2", "The steps block has no numbered steps. Write each step as a numbered-list item (1.).", true)
            end
          end

          if cls == "pair" then
            if not (parent == nil or parent == "steps") then
              report("N2", "A pair is inside another block. A pair goes at the top level or directly inside steps.", true)
            end
            local media = media_count(b.content)
            local has_text = false
            for _, c in ipairs(b.content) do
              if not is_media_block(c) and c.t ~= "RawBlock" then has_text = true end
            end
            if media == 0 then
              report("P1", "A pair has no screenshot or screen-loop. A pair holds text plus exactly one.", true)
            elseif media > 1 then
              report("P1", string.format("A pair has %d screenshots or loops. A pair holds exactly one.", media), true)
            end
            if not has_text then
              report("P1", "A pair has a screenshot but no text. Add the text that goes beside it.", true)
            end
          end

          if cls == "screen-loop" then
            local src = b.attributes.src
            if not src or src == "" then
              report("L1", "A screen-loop has no src. Add src=\"path/to/clip.webm\".", true)
            elseif not src_exists(src) then
              report("L1", string.format('A screen-loop points at "%s", which doesn\'t exist.', src), true)
            end
            local alt = b.attributes.alt
            if not alt or trim(alt) == "" then
              report("A1", string.format('The screen-loop "%s" has no alt text. Add alt="..." describing the action.',
                src or "(no src)"), true)
            end
          end
        end
      end

      for _, kids in ipairs(children(b)) do
        walk(kids, child_parent)
      end
    end
  end

  walk(doc.blocks, nil)

  -- T1: one title.
  if #h1s == 0 then
    report("T1", "The topic has no level-1 heading (# Title).")
  elseif #h1s > 1 then
    report("T1", string.format("The topic has %d level-1 headings. It needs exactly one, the title.", #h1s))
  end
  for _, h in ipairs(h1s) do
    if h.identifier ~= "" and id and id ~= "" and h.identifier ~= id then
      report("T1", string.format('The title\'s ID is "%s" but the front matter id is "%s". Remove the title\'s ID or make them match.',
        h.identifier, id))
    end
  end

  -- S1, S4: task structure.
  if is_task then
    for _, cls in ipairs { "prereq", "steps", "result" } do
      local n = counts[cls] or 0
      if n == 0 then
        report("S1", string.format('This task has no "%s" block. A task needs one prereq, one steps, and one result.', cls))
      elseif n > 1 then
        report("S1", string.format('This task has %d "%s" blocks. A task has exactly one.', n, cls))
      end
    end
    local p, s, r = positions.prereq, positions.steps, positions.result
    if p and s and p > s then
      report("S4", "The prereq block comes after steps. Put prereq first.")
    end
    if s and r and s > r then
      report("S4", "The result block comes before steps. Put result after steps.")
    end
  end

  -- A1: alt text on every image.
  pandoc.Blocks(doc.blocks):walk {
    Figure = function(fig)
      local caption = trim(stringify(fig.caption.long or {}))
      fig.content:walk {
        Image = function(img)
          local alt = img.attributes.alt and trim(img.attributes.alt) or ""
          local desc = trim(stringify(img.caption))
          if alt == "" and (desc == "" or desc == caption) then
            report("A1", string.format('The image "%s" has no alt text. Add alt="..." describing the screen.', img.src))
          end
        end,
      }
    end,
  }
  -- Images outside figures (inline with text).
  local function inline_images(blocks)
    for _, b in ipairs(blocks) do
      if b.t == "Figure" then
        -- checked above
      elseif b.t == "Para" or b.t == "Plain" then
        for _, il in ipairs(b.content) do
          if il.t == "Image" then
            local alt = il.attributes.alt and trim(il.attributes.alt) or ""
            if alt == "" and trim(stringify(il.caption)) == "" then
              report("A1", string.format('The image "%s" has no alt text. Add alt="..." describing the screen.', il.src))
            end
          end
        end
      else
        for _, kids in ipairs(children(b)) do inline_images(kids) end
      end
    end
  end
  inline_images(doc.blocks)

  if #problems > 0 then
    for _, p in ipairs(problems) do io.stderr:write(p, "\n") end
    os.exit(1)
  end
  return nil
end
