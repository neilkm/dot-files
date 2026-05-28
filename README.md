# Neil Karkhanis's Dotfiles

This repo contains a complete Neovim config in `./nvim`, a zsh prompt config in `./shell/zsh`, a Kitty terminal config in `./kitty`, and a tmux config in `./tmux`.

## What this setup does
- Uses `lazy.nvim` as the plugin manager.
- Starts with a dashboard that shows Neil's previous ASCII art.
- Installs and configures Neo-tree.
  - `<leader>e` toggles Neo-tree in the current window instead of opening a global sidebar
  - existing splits do not auto-resize when a new split is created (`noea`)
- Automatically reloads files changed outside Neovim when focus returns to the app or window.
- Automatically closes unmodified buffers whose files were deleted on disk.
- Provides practical keymaps for files, search, buffers, and diagnostics.
- Installs a custom interactive zsh setup:
  - enables `compinit` once per shell session
  - enables file-type colors for `ls`
  - uses a two-line prompt
  - shows a light-blue `[%n@%m]` host segment
  - truncates the displayed working directory to the last 3 path segments and prepends `.../` when deeper
  - shows the current Git branch in orange and appends `*` when the worktree is dirty
  - starts input on a second line prefixed with `└ $`
  - defines shell aliases:
    - `la`: `ls -laG` on macOS, `ls -la --color=auto` with GNU `ls`
    - `ll`: `ls -lG` on macOS, `ls -l --color=auto` with GNU `ls`
    - `gs`: `git status`
    - `gl`: `git log`
    - `gc`: `git commit`
    - `ga`: `git add --all`
    - `gp`: `git push`
    - `gg`: `git gui`
- Shows a zsh startup banner with:
  - banner art loaded from `./shell/zsh/login-banner-art.txt`
  - a framed stats block for uptime, CPU, memory usage, and storage usage
  - OSC 7 cwd updates so terminal apps can inherit the current directory
- Keeps ASCII art in a separate editable file: `./shell/zsh/login-banner-art.txt`.
- Installs Kitty config from `./kitty/kitty.conf`.
- Makes `kitty` new tabs/windows inherit the current working directory.
- Installs tmux config from `./tmux/tmux.conf`.
- Adds tmux split shortcuts:
  - `Ctrl-b` then `|`: vertical split
  - `Ctrl-b` then `-`: horizontal split
- Enables tmux mouse support.

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
- installs tmux config to `~/.tmux.conf`
- appends a source line to `~/.zshrc` (idempotent)
- enables zsh completion through the installed prompt config
- updates the shell prompt and banner behavior described above

## Keymaps
- `<Space>`: leader key
- `<leader>e`: toggle Neo-tree in the current window
- `<leader>t`: focus an existing terminal split, or open a new terminal at the bottom at about 15% height
- `<leader>ff`: find files (Telescope)
- `<leader>fg`: live grep (Telescope)
- `<leader>fb`: list open buffers (Telescope)
- `<leader>fh`: help tags (Telescope)
- `<leader>w`: save file
- `<leader>q`: quit window
- `<leader>x`: close current buffer
- `<leader>bd`: delete current buffer
- `<C-h>` / `<C-Left>`: focus split to the left
- `<C-j>` / `<C-Down>`: focus split below
- `<C-k>` / `<C-Up>`: focus split above
- `<C-l>` / `<C-Right>`: focus split to the right
- `[d`: previous diagnostic
- `]d`: next diagnostic
- `<leader>ld`: open diagnostic float
- `<leader>lq`: send diagnostics to quickfix list
- `<leader>gc`: toggle line comment
- `<Esc>`: clear search highlight
- `jk` (insert mode): escape to normal mode

## Notes
- First start may take longer while plugins install.
- Requires Neovim 0.9+ (0.10+ recommended).
- The startup banner is shown once per interactive zsh session.
- Login-shell messages such as `Last login` or `You have new mail.` come from the system, not from this repo.
