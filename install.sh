#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$REPO_DIR/nvim"
TARGET_DIR="$HOME/.config/nvim"
PROMPT_SOURCE="$REPO_DIR/shell/zsh/prompt.zsh"
PROMPT_TARGET_DIR="$HOME/.config/neil-shell"
PROMPT_TARGET="$PROMPT_TARGET_DIR/prompt.zsh"
ZSHRC_FILE="$HOME/.zshrc"
PROMPT_SOURCE_LINE='[[ -f "$HOME/.config/neil-shell/prompt.zsh" ]] && source "$HOME/.config/neil-shell/prompt.zsh"'

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source config not found at $SOURCE_DIR" >&2
  exit 1
fi

if [[ ! -f "$PROMPT_SOURCE" ]]; then
  echo "Error: prompt config not found at $PROMPT_SOURCE" >&2
  exit 1
fi

mkdir -p "$HOME/.config"
rm -rf "$TARGET_DIR"
cp -R "$SOURCE_DIR" "$TARGET_DIR"

mkdir -p "$PROMPT_TARGET_DIR"
cp "$PROMPT_SOURCE" "$PROMPT_TARGET"

if ! grep -Fq "$PROMPT_SOURCE_LINE" "$ZSHRC_FILE" 2>/dev/null; then
  printf "\n%s\n" "$PROMPT_SOURCE_LINE" >> "$ZSHRC_FILE"
fi

CURRENT_DATE_TIME="$(date '+%B %-d, %Y at %H:%M:%S')"
printf "Development environment last updated: %s\n" "$CURRENT_DATE_TIME" > "$TARGET_DIR/footer.txt"

echo "Installed: $TARGET_DIR"
echo "Installed: $PROMPT_TARGET"
echo "Updated: $ZSHRC_FILE"
