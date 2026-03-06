#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$REPO_DIR/nvim"
TARGET_DIR="$HOME/.config/nvim"
PROMPT_SOURCE="$REPO_DIR/shell/zsh/prompt.zsh"
PROMPT_ART_SOURCE="$REPO_DIR/shell/zsh/login-banner-art.txt"
KITTY_SOURCE="$REPO_DIR/kitty/kitty.conf"
PROMPT_TARGET_DIR="$HOME/.config/neil-shell"
PROMPT_TARGET="$PROMPT_TARGET_DIR/prompt.zsh"
PROMPT_ART_TARGET="$PROMPT_TARGET_DIR/login-banner-art.txt"
KITTY_TARGET_DIR="$HOME/.config/kitty"
KITTY_TARGET="$KITTY_TARGET_DIR/kitty.conf"
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

if [[ ! -f "$PROMPT_ART_SOURCE" ]]; then
  echo "Error: prompt art not found at $PROMPT_ART_SOURCE" >&2
  exit 1
fi

if [[ ! -f "$KITTY_SOURCE" ]]; then
  echo "Error: kitty config not found at $KITTY_SOURCE" >&2
  exit 1
fi

mkdir -p "$HOME/.config"
rm -rf "$TARGET_DIR"
cp -R "$SOURCE_DIR" "$TARGET_DIR"

mkdir -p "$PROMPT_TARGET_DIR"
cp "$PROMPT_SOURCE" "$PROMPT_TARGET"
cp "$PROMPT_ART_SOURCE" "$PROMPT_ART_TARGET"

mkdir -p "$KITTY_TARGET_DIR"
cp "$KITTY_SOURCE" "$KITTY_TARGET"

if ! grep -Fq "$PROMPT_SOURCE_LINE" "$ZSHRC_FILE" 2>/dev/null; then
  printf "\n%s\n" "$PROMPT_SOURCE_LINE" >> "$ZSHRC_FILE"
fi

CURRENT_DATE_TIME="$(date '+%B %-d, %Y at %H:%M:%S')"
printf "Development environment last updated: %s\n" "$CURRENT_DATE_TIME" > "$TARGET_DIR/footer.txt"

echo "Installed: $TARGET_DIR"
echo "Installed: $PROMPT_TARGET"
echo "Installed: $PROMPT_ART_TARGET"
echo "Installed: $KITTY_TARGET"
echo "Updated: $ZSHRC_FILE"
