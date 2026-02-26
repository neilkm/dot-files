#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$REPO_DIR/nvim"
TARGET_DIR="$HOME/.config/nvim"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source config not found at $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$HOME/.config"
rm -rf "$TARGET_DIR"
cp -R "$SOURCE_DIR" "$TARGET_DIR"

CURRENT_DATE_TIME="$(date '+%B %-d, %Y at %H:%M:%S')"
printf "Development environment last updated: %s\n" "$CURRENT_DATE_TIME" > "$TARGET_DIR/footer.txt"

echo "Installed: $TARGET_DIR"
