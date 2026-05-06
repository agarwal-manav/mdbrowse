#!/bin/bash
# One-liner installer for mdbrowse.
# Usage: curl -fsSL https://raw.githubusercontent.com/agarwal-manav/mdbrowse/main/remote-install.sh | bash

set -e

REPO="https://github.com/agarwal-manav/mdbrowse.git"
DEST="$HOME/.mdbrowse"

if [ -d "$DEST/.git" ]; then
  echo "==> updating $DEST"
  git -C "$DEST" pull --ff-only
else
  echo "==> cloning into $DEST"
  git clone "$REPO" "$DEST"
fi

bash "$DEST/install.sh"
