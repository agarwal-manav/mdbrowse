#!/bin/bash
# Double-click to open the File Browser in Chrome.
# (macOS .command files run in Terminal; we open the app and exit.)

cd "$(dirname "$0")"
APP_HTML="$(pwd)/index.html"

# Prefer Google Chrome (full File System Access API support); fall back to default browser.
if [ -d "/Applications/Google Chrome.app" ]; then
  open -a "Google Chrome" "$APP_HTML"
elif [ -d "/Applications/Microsoft Edge.app" ]; then
  open -a "Microsoft Edge" "$APP_HTML"
else
  echo "WARN: Chrome / Edge not found — opening in your default browser. Folder open may not work in Safari/Firefox."
  open "$APP_HTML"
fi
