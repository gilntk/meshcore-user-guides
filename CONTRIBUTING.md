# Contributing

Thanks for helping with the MeshCore User Guides. This file explains how
the project is put together and how contributions are licensed. It's for
contributors and isn't part of the published guides.

Before you write, read:

- `spec/topic-types.md`: topic types, front matter, the blocks you can
  use, and the rules `tools/validate-topic-files` checks.
- `STYLE.md`: voice, images, and how interface text appears.
- `wordlist.md`: the project's terms.

Start each new topic by copying a template from `templates/`, and run
`tools/validate-topic-files` before you open a pull request.

## For DITA authors

If you've written in DITA, the model here will be familiar. Topics follow
DITA's authoring principles (topic types, short descriptions, task
structure, minimalism, separate content and presentation), expressed in
Pandoc Markdown instead of XML. The schema's job is done by
`tools/validate-topic-files`, and DITA-OT's job by Quarto.

| DITA | Here |
|---|---|
| Topic | One Markdown file in `docs/`. |
| Topic type (`<concept>`, `<task>`) | Front matter `type: concept` or `type: task`. Reference topics are planned but not set up yet. |
| `@id` | Front matter `id`, also used as the file name. |
| `<title>` | The level-1 heading (`# Title`). |
| `<shortdesc>` | Front matter `description`. It prints as the topic's first paragraph, so it doubles as the introduction. |
| `<prolog>` metadata | Front matter, such as `app_version`. |
| `<conbody>`, `<taskbody>` | The body of the file. There's no wrapper. |
| `<section>` | A level-2 heading (`##`) and the content under it, until the next one. Sections are optional. |
| `<prereq>` | A `::: prereq` block. |
| `<steps>`, `<step>` | A `::: steps` block holding a numbered list. Each list item is one step. Type `1.` for every step; the build numbers them. |
| `<cmd>`, `<info>`, `<stepresult>` | No separate elements. The step's first sentence is the action; any further sentences or paragraphs in the list item are the extra information. |
| `<result>` | A `::: result` block. |
| `<note type="note">`, `"tip"`, `"caution"` | `::: note`, `::: tip`, `::: warning`. |
| `<fig>`, `<image>` with `<alt>` | A Markdown image with an `alt` attribute. |
| `<object>` (video) | A `::: screen-loop` block. |
| No equivalent | A `::: pair` block: text on the left, one screenshot on the right. |
| `<uicontrol>` | **Bold**, with the label exactly as the app shows it. |
| `<menucascade>` | **Menu ▸ Item**. |
| `<xref>` to a topic | A Markdown link to its file: `[Learn the UI](learn-the-ui.md)`. |
| `<xref>` to a section | A link to the section's ID: `[The main screen](learn-the-ui.md#main-screen)`. |
| Map (`.ditamap`) | The chapter list in `_quarto.yml`. |
| `conref`, `keyref`, DITAVAL | No equivalent yet. Reuse and conditional content are planned for when the guides need them. |
| DTD validation | `tools/validate-topic-files`, which enforces `spec/topic-types.md`. |
| DITA-OT | Quarto, which builds the website and the PDF. |

A few things work differently from DITA:

- **Plain Markdown by default.** Only the blocks in the table use `:::`
  fences. Paragraphs, lists, and headings are ordinary Markdown.
- **No nested topics.** A file is one topic. Chapters are built from
  topics in the chapter list, not by nesting topics inside topics.
- **Validation runs outside the editor.** No editor stops you from typing
  an invalid structure, so run `tools/validate-topic-files` as you work.
  It also runs on every pull request.

## Licensing your contributions

The project's writing is licensed under CC BY 4.0, and its code under the
MIT License. See `LICENSE`. By contributing, you agree that your
contribution is licensed the same way: writing and media under CC BY 4.0,
code under MIT.
