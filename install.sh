#!/usr/bin/env bash
# Install hmux: symlink bin/hmux onto your PATH and seed sample project
# layouts into ~/.config/herdr/projects/. Safe to re-run — never overwrites
# an existing layout file.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HMUX_BIN_DIR:-$HOME/.local/bin}"
PROJECTS_DIR="$HOME/.config/herdr/projects"

mkdir -p "$BIN_DIR" "$PROJECTS_DIR"

ln -sf "$REPO_DIR/bin/hmux" "$BIN_DIR/hmux"
echo "linked: $BIN_DIR/hmux -> $REPO_DIR/bin/hmux"

for f in "$REPO_DIR"/projects/*; do
  base="$(basename "$f")"
  dest="$PROJECTS_DIR/$base"
  if [[ -e "$dest" ]]; then
    echo "skip (already exists): $dest"
  else
    cp "$f" "$dest"
    echo "installed: $dest"
  fi
done

echo

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "NOTE: $BIN_DIR is not on your PATH. Add to your shell rc:"
     echo "  export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac

command -v herdr >/dev/null 2>&1 || echo "NOTE: herdr not found on PATH — install it before running hmux."
command -v jq    >/dev/null 2>&1 || echo "NOTE: jq not found on PATH — install it (e.g. 'brew install jq')."

echo "Done. Run 'herdr' once per session, then 'hmux <project>' to launch a workspace."
