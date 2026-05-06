# File Browser

A zero-install, single-page file browser for inspecting any folder or file on your Mac.

## Install

One-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/agarwal-manav/mdbrowse/main/remote-install.sh | bash
```

This clones the repo into `~/.mdbrowse` and symlinks `mdbrowse` into `/opt/homebrew/bin/` (or `~/.local/bin/` as a fallback). Re-run the same command later to update. Pure Python 3 stdlib — no dependencies.

Manual alternative:

```bash
git clone https://github.com/agarwal-manav/mdbrowse.git
cd mdbrowse
./install.sh
```

## How to launch

### From Finder
Double-click **`Open File Browser.command`** — it opens the app in Chrome (or Edge if Chrome isn't installed).

### From a terminal — `mdbrowse`
A `mdbrowse` command is symlinked into `/opt/homebrew/bin/mdbrowse`, so it works anywhere:

```bash
mdbrowse                              # idle app, "Markdown only" defaults to ON
mdbrowse vTax/containerize-executor   # serves the folder over a localhost HTTP
                                      # server and opens the app pointed at it
mdbrowse vTax -a                      # same, but show every file (not just .md)
mdbrowse vTax/README.md               # render a single file directly in Chrome
mdbrowse agarwal-manav/mdbrowse       # shallow-clone a GitHub repo and serve it
mdbrowse https://github.com/owner/repo
mdbrowse Meesho/containerize-model#30 # check out a PR; tree is restricted to its
                                      # changed files plus a synthesised _PR.md
mdbrowse https://github.com/owner/repo/pull/123
```

PR mode requires the GitHub CLI (`brew install gh`) — it's used for `gh pr view` (metadata + comments + reviews) and `gh pr checkout` (so fork PRs work). The synthesised `_PR.md` includes title, description, branch, diff stats, labels, file list, reviews, and issue comments.

In served-folder mode the toolbar shows a **"Search docs..."** box that does full-text search across every `.md` file (case-insensitive, with line snippets). Click any result to open the file at that line.

For folders, `mdbrowse` spins up a tiny Python `http.server` rooted at the
target dir, so the app can fetch files via HTTP without needing the manual
folder-picker click. Press **Ctrl+C** in the terminal to stop the server.

If you don't have `/opt/homebrew/bin` on PATH (or want a different location):

```bash
ln -sf "$HOME/Desktop/Meesho-Work/file-browser/mdbrowse" "$HOME/.local/bin/mdbrowse"
```

### Manual fallback
```bash
open -a "Google Chrome" "$HOME/Desktop/Meesho-Work/file-browser/index.html"
```

URL query params accepted by the app:

| Param | Effect |
|---|---|
| `?mdOnly=0` | start with the "Markdown only" toggle off |
| `?mdOnly=1` | start with it on (default) |
| `?serve=1` | served-folder mode — fetch tree from `/__mdbrowse__/tree.json`. Set automatically by the `mdbrowse` CLI. |

## What it does

- **Open Folder** — picks a folder and recursively walks every subfolder. Uses Chrome / Edge's File System Access API. The whole tree is indexed once and shown on the left.
- **Open File** — opens a single file (works in any browser).
- **Filter box** — narrows the tree by filename (case-insensitive).
- **Click any file** to view it on the right.

## Renderers

| File kind | Rendered as |
|---|---|
| `.md` / `.markdown` / `.mdx` | parsed Markdown with tables, code blocks, links |
| `.html` / `.htm` | sandboxed iframe + raw source toggle |
| `.png` / `.jpg` / `.gif` / `.webp` / `.avif` / `.svg` / `.bmp` / `.ico` | image preview |
| `.mp4` / `.webm` / `.mov` | video player |
| `.mp3` / `.wav` / `.ogg` / `.flac` | audio player |
| `.pdf` | embedded PDF viewer |
| `.json` / `.yaml` / `.toml` / `.ini` | syntax-highlighted text |
| `.py` / `.go` / `.java` / `.kt` / `.rs` / `.ts` / `.tsx` / `.js` / `.jsx` / `.css` / `.scss` / `.sql` / `.sh` / `Dockerfile` | syntax-highlighted code (Prism) |
| `.txt` / `.log` / `.cql` / `.jsonl` / `.csv` / `.env` / unknown text | plain `<pre>` |
| Anything else (binary) | "Download" link |

Files larger than 5 MB show a "too large" notice instead of trying to render.

## Browser support

- **Open Folder**: Chrome 86+, Edge 86+ (needs File System Access API).
- **Open File**: works in any modern browser, including Safari and Firefox.

## Skipped folders

To keep the tree scannable, these folder names are silently skipped:

```
.git  node_modules  __pycache__  .DS_Store  .next  dist  build  .venv  venv
```

If you need to see those, edit `shouldSkip()` in `index.html`.

## Known caveats

- **Read-only.** This is a viewer; it never writes back to disk.
- **Permissions.** Chrome will prompt the first time you open a folder; if you cancel the prompt nothing happens.
- **Large folders.** The whole tree is indexed up front, so extremely deep / wide trees (a `node_modules` you forgot to skip, say) can take a few seconds.
