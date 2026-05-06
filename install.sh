#!/bin/bash
# Symlink `mdbrowse` onto your PATH.
# Re-run any time after `git pull`; the symlink keeps pointing at the repo.

set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

# Pick a bin dir that's on PATH.
if [ -d "/opt/homebrew/bin" ] && [ -w "/opt/homebrew/bin" ]; then
  BIN="/opt/homebrew/bin"
elif [ -d "$HOME/.local/bin" ]; then
  BIN="$HOME/.local/bin"
else
  mkdir -p "$HOME/.local/bin"
  BIN="$HOME/.local/bin"
  echo "note: created $BIN — make sure it's on your PATH"
fi

chmod +x "$DIR/mdbrowse"
ln -sf "$DIR/mdbrowse" "$BIN/mdbrowse"
echo "installed: $BIN/mdbrowse -> $DIR/mdbrowse"
echo "try: mdbrowse --help"
