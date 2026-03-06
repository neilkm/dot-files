# Neil Karkhanis's Dotfiles

This repo contains a complete Neovim config in `./nvim`, a zsh prompt config in `./shell/zsh`, and a Kitty terminal config in `./kitty`.

## What this setup does
- Uses `lazy.nvim` as the plugin manager.
- Starts with a dashboard that shows Neil's previous ASCII art.
- Installs and configures Neo-tree.
- Provides practical keymaps for files, search, buffers, and diagnostics.
- Installs a custom zsh prompt:
  - `User@Device full/path/to/current/dir [branch]*`
  - Git branch is orange.
  - `*` appears when there are uncommitted changes.
- Shows a zsh startup banner with system stats.
- Keeps ASCII art in a separate editable file: `./shell/zsh/login-banner-art.txt`.
- Installs Kitty config from `./kitty/kitty.conf`.

## Install (overwrite current Neovim config)
Run:

```bash
./install.sh
```

This script:
- force-overwrites `~/.config/nvim` with `./nvim` from this repo
- installs prompt config to `~/.config/neil-shell/prompt.zsh`
- installs banner art to `~/.config/neil-shell/login-banner-art.txt`
- installs kitty config to `~/.config/kitty/kitty.conf`
- appends a source line to `~/.zshrc` (idempotent)

## Keymaps
- `<Space>`: leader key
- `<leader>e`: toggle Neo-tree file explorer
- `<leader>ff`: find files (Telescope)
- `<leader>fg`: live grep (Telescope)
- `<leader>fb`: list open buffers (Telescope)
- `<leader>fh`: help tags (Telescope)
- `<leader>w`: save file
- `<leader>q`: quit window
- `<leader>x`: close current buffer
- `<leader>bd`: delete current buffer
- `[d`: previous diagnostic
- `]d`: next diagnostic
- `<leader>ld`: open diagnostic float
- `<leader>lq`: send diagnostics to quickfix list
- `<Esc>`: clear search highlight
- `jk` (insert mode): escape to normal mode

## Notes
- First start may take longer while plugins install.
- Requires Neovim 0.9+ (0.10+ recommended).
