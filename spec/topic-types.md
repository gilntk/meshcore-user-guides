# Topic types

This is the content contract for the guides: what a topic file contains,
which blocks you can use, and the rules the checker enforces. Every rule
below has a code, and the checker prints that code with each problem it
finds, so you can look the rule up here.

How the guides are written (voice, images, UI text) is in `STYLE.md`.
Terms are in `wordlist.md`.

## Topic files

- One topic per file, in `docs/`. A chapter is made of one or more topics.
- Name the file after the topic's `id`: `channels-create-private.md`.
- Start a new topic by copying the matching template in `templates/`.

## Front matter

Every topic starts with YAML front matter:

```yaml
---
id: channels-create-private
type: task
description: >-
  Create a private channel when you want an encrypted group conversation
  that only invited people can read.
app_version: "1.47"
---
```

| Field | Required | What it holds |
|---|---|---|
| `id` | yes | The topic's permanent name. Lowercase letters, digits, and hyphens. Unique across all three books. Never change it once assigned. |
| `type` | yes | `concept` or `task`. |
| `description` | yes | The topic's introductory paragraph and short description in one. It prints as the first full paragraph on the page, so don't repeat it in the body. Length is your call. |
| `app_version` | no | The app version the topic describes, in quotes (`"1.47"`). |

The `>-` after `description:` lets the paragraph run over several lines.

## Title

Each topic has exactly one level-1 heading, its title. You don't need to
give it an ID; the build uses the front matter `id`. If you do give it one,
it must match `id`.

## Topic types

### Concept

Explains what something is or how it works: a screen, an idea, a set of
options. A concept can use any block except `prereq`, `steps`, and
`result`.

### Task

Walks the reader through one procedure. A task has, in this order:

1. One `prereq` block: what must be true before starting.
2. One `steps` block: the procedure, one action per step.
3. One `result` block: what the reader has when they're done.

Write each step as an ordinary numbered-list item. You can type `1.` for
every step; the build numbers them, and numbering continues across `pair`
blocks inside `steps`.

## Blocks

Most of a topic is plain Markdown. Use a fenced div (`:::`) only for these
blocks:

| Block | Use it for | Allowed |
|---|---|---|
| `pair` | Text with one screenshot or loop beside it. Text goes on the left (60%), the screenshot on the right (40%). | At the top level of any topic, or directly inside `steps`. |
| `steps` | The procedure in a task. | Tasks only, at the top level. |
| `prereq` | Prerequisites. | Tasks only, at the top level. |
| `result` | The outcome of the procedure. | Tasks only, at the top level. |
| `note` | Information the reader should notice. | Anywhere. |
| `tip` | A helpful shortcut or alternative. | Anywhere. |
| `warning` | Something that can cause a problem or lose data. | Anywhere. |
| `screen-loop` | A short looping clip showing an action. The PDF shows its last frame. | Anywhere; usually inside `pair`. |

Each closing `:::` closes the most recently opened block. When one block
holds another, give the outer one a longer fence (`::::` around `:::`) so
the nesting is easy to see. Pandoc doesn't require it, but it's the house
convention.

### pair

```markdown
::: pair
The Contacts screen lists your contacts.

![](media/contacts/contacts-screen.png){#fig:contacts-screen alt="A phone screenshot of the Contacts screen..."}
:::
```

Everything in a `pair` except the screenshot is its text: paragraphs,
headings, lists, or steps. The column widths come from the stylesheet, so
don't set a `width` on the image.

### screen-loop

```markdown
::: {.screen-loop src="media/channels/channels-add_app-1.47.webm" alt="The Add Channel menu opening, then Create a Private Channel being tapped."}
:::
```

`src` is the clip and `alt` describes the action. Anything you write inside
the block is its caption.

## Rules the checker enforces

| Code | Rule |
|---|---|
| F1 | Front matter has `id`, `type`, and `description`, and none are empty. |
| F2 | `type` is `concept` or `task`. |
| F3 | `id` uses only lowercase letters, digits, and hyphens. |
| U1 | No two topics share an `id`. |
| T1 | The topic has exactly one level-1 heading, and any ID on it matches `id`. |
| S1 | A task has exactly one `prereq`, one `steps`, and one `result` block. |
| S2 | A `steps` block contains at least one numbered step. |
| S3 | `prereq`, `steps`, and `result` appear only in tasks. |
| S4 | In a task, `prereq` comes before `steps`, and `steps` before `result`. |
| V1 | Every fenced div has exactly one class, and it's one of the blocks listed above. |
| N1 | `prereq`, `steps`, and `result` sit at the top level, not inside another block. |
| N2 | A `pair` sits at the top level or directly inside `steps`. |
| P1 | A `pair` holds some text and exactly one screenshot or `screen-loop`. |
| L1 | A `screen-loop` has a `src` that points at a file that exists. |
| A1 | Every image and `screen-loop` has alt text in its `alt` attribute. |

## Checking your work

From the top of the repo:

```sh
tools/check                         # check every topic in docs/
tools/check docs/some-topic.md      # check one topic
```

To re-check a topic each time you save it, in any editor, run a watch
command in a terminal window (install `entr` first with
`brew install entr`):

```sh
find docs -name '*.md' | entr -c tools/check /_
```

The same check runs when you commit, on every pull request, and before
every build.
