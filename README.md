# mdbrowse

A zero-install local file browser tuned for reviewing markdown — folders, repos, or GitHub PRs. Renders markdown with TOC, full-text search, sticky headings, Mermaid diagrams, syntax-highlighted code, and (in PR mode) inline review comments you can post back to GitHub from the viewer.

## Install

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/agarwal-manav/mdbrowse/main/remote-install.sh | bash
```

Clones the repo into `~/.mdbrowse` and symlinks `mdbrowse` into `/opt/homebrew/bin/` (or `~/.local/bin/` as a fallback). Re-run the same command to update. Pure Python 3 stdlib — no Python deps. PR mode also requires the GitHub CLI (`brew install gh`).

Manual alternative:

```bash
git clone https://github.com/agarwal-manav/mdbrowse.git
cd mdbrowse && ./install.sh
```

## Usage

```bash
mdbrowse                                # idle app, "Markdown only" toggle on
mdbrowse path/to/folder                 # serve a local folder
mdbrowse path/to/folder -a              # same, but show all files (not just .md)
mdbrowse path/to/file.md                # open a single file directly in Chrome

mdbrowse owner/repo                     # shallow-clone a GitHub repo and serve it
mdbrowse https://github.com/owner/repo

mdbrowse owner/repo#123                 # check out a PR; tree restricted to its
                                        # changed files plus a synthesised _PR.md
mdbrowse https://github.com/owner/repo/pull/123
```

`mdbrowse` spins up a tiny localhost HTTP server rooted at the target, opens it in Chrome, and exits on Ctrl+C.

## What it gives you

### Folder & repo mode
- Full tree, expanded by default. Click any file to render on the right.
- **Filename filter** (`/`) and **full-text search** across all `.md` files (`?` shortcut), with ranked results, hit counts, and line snippets.
- **Refresh button** rescans the directory so newly-added or edited files appear without restarting the server.
- **Mermaid** code blocks render to flow diagrams.
- **Jira-style ticket links** (`MEESHO-1234`, `INVENT-42`) auto-link to `meesho.atlassian.net`.
- **TOC sidebar** for any markdown file with 3+ headings (right rail; click to scroll).
- **Sticky h2** keeps section context while scrolling long docs.
- **Open in GitHub** button on any file in a cloned repo / PR — jumps to the file at the pinned head SHA.

### PR mode (extra features)
Triggered when you pass `owner/repo#N` or a `github.com/.../pull/N` URL.

- Tree is restricted to the PR's changed files. A synthesized `_PR.md` at the root contains: title, branch, diff stats, labels, full description, file list, reviews, and issue comments.
- Existing **line-anchored review comments** are pulled (via `gh api`) and shown inline next to the block they target in the rendered markdown.
- **Comment from the viewer.** Hover any block in rendered markdown — a 💬 button appears. Click to open an inline composer; submit posts as a real GitHub review comment on the line that block maps to (server shells to `gh api ... pulls/N/comments`).
- For pixel-precise commenting, click **💬 Comment mode** in the toolbar — switches to a numbered source view where each diff line has its own + gutter.
- Submit shortcuts: `Cmd+Enter` (or `Ctrl+Enter`) to send, `Esc` to cancel.

## Keyboard shortcuts

| Key | Action |
|---|---|
| `j` / `↓` | Next file in the tree |
| `k` / `↑` | Previous file |
| `/` | Focus filename filter |
| `?` | Focus content search |
| `g` | Open current file on GitHub |
| `r` | Refresh tree (served mode) |
| `Esc` | Blur the current input |

## Supported file types

| File kind | Rendered as |
|---|---|
| `.md` / `.markdown` / `.mdx` | Parsed markdown with tables, code blocks, Mermaid, Jira links, TOC |
| `.html` / `.htm` | Sandboxed iframe + raw source toggle |
| `.png` / `.jpg` / `.gif` / `.webp` / `.avif` / `.svg` / `.bmp` / `.ico` | Image preview |
| `.mp4` / `.webm` / `.mov` | Video player |
| `.mp3` / `.wav` / `.ogg` / `.flac` | Audio player |
| `.pdf` | Embedded PDF viewer |
| `.json` / `.yaml` / `.toml` / `.ini` | Syntax-highlighted text |
| `.py` / `.go` / `.java` / `.kt` / `.rs` / `.ts` / `.tsx` / `.js` / `.jsx` / `.css` / `.sql` / `.sh` / `Dockerfile` | Syntax-highlighted (Prism) |
| `.txt` / `.log` / `.csv` / `.env` / unknown text | Plain `<pre>` |
| Anything else (binary) | Download link |

Files larger than 5 MB show a "too large" notice instead of rendering.

## Skipped directories

These names are silently skipped when walking the tree (edit `SKIP_DIRS` in `mdbrowse` to change):

```
.git  node_modules  __pycache__  .DS_Store  .next  dist  build  .venv  venv
```

## URL query params (when opening `index.html` directly)

| Param | Effect |
|---|---|
| `?mdOnly=0` | start with "Markdown only" off |
| `?mdOnly=1` | start with it on (default) |
| `?serve=1` | served-folder mode — fetch tree from `/__mdbrowse__/tree.json`. Set automatically by the CLI. |

## Browser support

- **Open Folder** (manual file picker): Chrome 86+, Edge 86+ — requires the File System Access API.
- **Served folder / repo / PR**: any modern Chrome / Edge. Single-file rendering works in Safari and Firefox too.

## Caveats

- **Permissions.** Chrome prompts the first time you open a folder via the manual picker; cancel ⇒ nothing happens.
- **Large repos.** The whole tree is indexed up front. Folders with thousands of files (a `node_modules` you forgot to skip, say) can take a few seconds.
- **PR comment posting** writes to GitHub via the user's authenticated `gh` CLI. There is no draft/review-staging — submitting fires the comment immediately.
- **Block-line mapping** in rendered-markdown commenting is best-effort. If your block spans many lines and only some are in the PR diff, the posted comment lands on the first commentable line in that range. Use Comment mode for line-precise control.
