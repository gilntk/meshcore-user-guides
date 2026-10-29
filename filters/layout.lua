--[[
layout.lua: turns the content contract's blocks into page layout.

Runs during `quarto render` and `quarto preview`, before Quarto's own
processing. It never changes what a topic says, only how it's laid out.
Topics are checked against the contract first by tools/validate-topic-files,
so this filter can assume they're well formed.

What it does now (HTML):
- Title: gives the topic's level-1 heading the front matter `id` as its ID.
- Description: prints the front matter `description` as the first
  paragraph under the title.
- pair: splits the block into a text column and a screenshot column.
  The 60/40 widths are set in styles/style.css.
- steps: numbers the steps continuously. Every pair inside a steps block
  breaks the Markdown list into separate lists, so this filter counts the
  steps in order and tells each list which number to start at. Writers can
  type 1. for every step.

Still to come: `screen-loop` video, and the PDF (Typst) versions of each.
]]

local stringify = pandoc.utils.stringify

-- Is this block the pair's screenshot: a figure, a loop, or a paragraph
-- holding nothing but an image?
local function is_media(b)
  if b.t == "Figure" then return true end
  if b.t == "Div" and b.classes:includes("screen-loop") then return true end
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

-- Number the steps in a steps block continuously: walk its lists in
-- document order, including lists inside pairs, and start each list one
-- past the last step before it.
local function number_steps(div)
  local count = 0
  local function visit(blocks)
    for _, b in ipairs(blocks) do
      if b.t == "OrderedList" then
        b.start = count + 1
        count = count + #b.content
      elseif b.t == "Div" then
        visit(b.content)
      end
    end
  end
  visit(div.content)
  return div
end

local function pair(div)
  local text, media = pandoc.Blocks {}, pandoc.Blocks {}
  for _, b in ipairs(div.content) do
    if is_media(b) then media:insert(b) else text:insert(b) end
  end
  div.content = pandoc.Blocks {
    pandoc.Div(text, pandoc.Attr("", { "pair-text" })),
    pandoc.Div(media, pandoc.Attr("", { "pair-media" })),
  }
  return div
end

function Pandoc(doc)
  local id = doc.meta.id and stringify(doc.meta.id) or nil
  local desc = doc.meta.description

  local shortdesc = desc and pandoc.Div(pandoc.Para(desc), pandoc.Attr("", { "shortdesc" }))

  -- In a Quarto book, Quarto has already moved the title out of the body
  -- and into the page header by the time this filter runs, so the
  -- description goes first in the body, right under that header. Outside
  -- Quarto, the title is still in the body; it gets the topic's id and the
  -- description goes right after it.
  local blocks = pandoc.Blocks {}
  local done_title = false
  for _, b in ipairs(doc.blocks) do
    blocks:insert(b)
    if not done_title and b.t == "Header" and b.level == 1 then
      done_title = true
      if id and id ~= "" and b.identifier == "" then b.identifier = id end
      if shortdesc then blocks:insert(shortdesc) end
    end
  end
  if not done_title and shortdesc then blocks:insert(1, shortdesc) end
  doc.blocks = blocks

  -- Number steps first, while each step is still in writing order, then
  -- split the pairs into columns.
  doc.blocks = doc.blocks:walk { Div = function(d)
    if d.classes:includes("steps") then return number_steps(d) end
  end }
  doc.blocks = doc.blocks:walk { Div = function(d)
    if d.classes:includes("pair") then return pair(d) end
  end }
  return doc
end
