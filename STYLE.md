# Style guide

This is the style guide for the project. It covers how the guides are
written and how their source is put together: file organization, Pandoc
Markdown, images, and how interface text appears on the page. It applies to
every contributor, human or AI, and to every file in `docs/`.

Terminology lives in a separate file, `wordlist.md`.

## Files and structure

- Write one Markdown file per chapter, named with a two-digit number for its
  place in reading order and a slug of its title:
  `<nn>-<chapter-slug>.md`.
- Start each chapter with a level-1 heading carrying an explicit ID that
  matches its slug: `# Chapter Title {#chapter-slug}`.
- Give every section you link to an explicit ID (`{#section-id}`) so links
  survive heading edits. Link with `[Section title](#section-id)`.

## Pandoc Markdown

- Notes and warnings use fenced divs, so HTML and PDF can style them:

  ```
  ::: note
  Text of the note.
  :::
  ```

  Allowed classes: `note`, `tip`, `warning`.
- Things to check against the app go in HTML comments that start with
  `VERIFY:`. Run `grep -rn "VERIFY:" docs` before a release; none should remain.

## Images

Images go in `media/<chapter-slug>/` and are inserted with an ID and alt
text. Use lowercase, hyphenated file names that describe what's shown, never
the capture date.

Captions are optional. Decide chapter by chapter whether a caption adds
something the surrounding heading and text don't, such as the key to an
annotated screenshot. To leave one out, keep the square brackets empty:
`![](media/chapter-slug/image-name.png){...}`. When a section leaves out
captions, say why in an HTML comment at the top of the section.

### Alt text

Every image and video must have alt text, so the documentation is accessible
to readers who use a screen reader or can't load images. A figure without alt
text isn't ready to publish.

- Write alt text in the `alt` attribute, separate from the caption. The
  caption names the figure; the alt text describes it.
- Describe what a sighted reader would take from the image, in the order
  they'd scan it: top to bottom, left to right. Say where things are on the
  screen ("along the bottom", "on the right edge") and what state they're in
  ("the Contacts tab is highlighted").
- For annotated screenshots, name each numbered region and where it sits.
- Use full sentences. Don't start with "Image of" or "Picture of"; start with
  what it is, such as "A phone screenshot of…".

### Screenshots

Insert phone screenshots as PNG at `width=40%`, which keeps them readable in
the PDF.

Crop every screenshot to the outline of the phone, with no drop shadow and
no padding around it. On a Mac, take window screenshots without the shadow:
press Cmd-Shift-4, then Space, then hold Option while you click the window.
An annotated screenshot can keep just enough transparent margin for its
number badges; widen its `width` so the phone shows at the same size as the
others.

Draw a 2-pixel mid-gray outline (RGB 168, 172, 180) around the phone's
edge on every screenshot without callouts, so light screens don't blend into
a white page. The outline follows the phone's rounded corners and sits just
outside its edge, with transparent space beyond it. Annotated screenshots
with numbered callouts don't get the outline.

```
![Caption sentence.](media/chapter-slug/image-name.png){#fig:image-name width=40% alt="Description of the screen."}
```

### Looping videos

On the website, use a short looping WebM to show an action, such as a
gesture or a screen changing. Insert it the same way as a screenshot, with
attributes that make it play silently on a loop. Put the alt text in both
`alt` and `aria-label`: browsers don't read `alt` on a video, so
`aria-label` is what a screen reader announces.

```
![Caption sentence.](media/chapter-slug/video-name.webm){#fig:video-name width=40% alt="Description of the action." aria-label="Description of the action." autoplay="" loop="" muted="" playsinline=""}
```

The PDF can't play video, so every WebM needs a still PNG with the same file
name (`video-name.png`) for the PDF to use in its place.

## UI text

- **Bold** every label exactly as the app shows it, including its
  capitalization.
- Describe an icon that has no label by its shape the first time it
  appears, then use its name from `wordlist.md`.
- Give every icon-only button a name in words, with the icon as a visual
  hint in parentheses. Screen readers read a bare symbol by its character
  name, or not at all, which tells the listener nothing.
- Call a three-dot (⋮) button the **row menu**, written as "the row menu
  (⋮)". Say whose row it is when that isn't clear: "the header's row menu",
  "a contact's row menu".
- Write menu paths with ▸ between bold labels: **Menu ▸ Item**.
- Use `code` only for things the reader types or sees as raw values, such as
  channel names, public keys, and CLI commands.

## Gestures and verbs

| Use | Don't use |
|---|---|
| tap | click, press, select (for touch targets) |
| touch and hold | long-press, press and hold, tap and hold, long-tap |
| swipe | slide |
| drag | pan, slide (moving a map or an item) |
| pinch | pinch-zoom, spread (zooming in or out) |
| enable / disable | turn on / turn off, toggle (for switches) |
| enter | type in, input (for text fields) |
| choose | select, pick (for lists and menus) |
