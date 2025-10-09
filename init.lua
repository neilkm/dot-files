-- ~/.config/nvim/init.lua

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim","MunifTanjim/nui.nvim","nvim-tree/nvim-web-devicons" },
    config = function()
      require("neo-tree").setup({
        -- close_if_last_window = false,
        -- popup_border_style = "NC",
        -- enable_git_status = true,
        -- enable_diagnostics = true,
        -- open_files_do_not_replace_types = { "terminal","trouble","qf" },
        -- sort_case_insensitive = false,
        -- sort_function = function(a,b) return a.path < b.path end,

        default_component_configs = {
          -- container = { enable_character_fade = true },
          -- indent = { indent_size = 2, padding = 1, with_markers = true, indent_marker = "│", last_indent_marker = "└" },
          -- icon = { folder_closed = "", folder_open = "", folder_empty = "", default = "" },
          -- modified = { symbol = "●" },
          -- name = { use_git_status_colors = true },
          -- git_status = {
          --   symbols = {
          --     added = "✚", modified = "", deleted = "", renamed = "",
          --     untracked = "", ignored = "", unstaged = "", staged = "", conflict = "",
          --   },
          -- },
        },

        window = {
          -- position = "left", -- "left"|"right"|"float"|"current"
          -- width = 35,
          -- mappings = {
          --   ["<space>"] = { "toggle_node", nowait = true },
          --   ["<cr>"] = "open", ["l"] = "open", ["h"] = "close_node",
          --   ["q"] = "close_window", ["R"] = "refresh",
          --   ["a"] = { "add", config = { show_path = "relative" } },
          --   ["A"] = "add_directory", ["d"] = "delete", ["r"] = "rename",
          --   ["y"] = "copy_to_clipboard", ["x"] = "cut_to_clipboard",
          --   ["p"] = "paste_from_clipboard", ["c"] = "copy", ["m"] = "move",
          --   ["P"] = { "toggle_preview", config = { use_float = true } },
          --   -- ["t"] = "open_tabnew", ["S"] = "split_with_window_picker", ["s"] = "vsplit_with_window_picker",
          -- },
        },

        -- source_selector = { winbar = false, statusline = false },
        sources = { "filesystem","buffers","git_status" },
        -- add "document_symbols" to sources to enable LSP symbols

        filesystem = {
          -- follow_current_file = { enabled = true, leave_dirs_open = false },
          -- use_libuv_file_watcher = true,
          -- filtered_items = {
          --   visible = true, hide_dotfiles = false, hide_gitignored = false, hide_hidden = false,
          --   hide_by_name = { ".DS_Store","thumbs.db" }, hide_by_pattern = { "*.meta" },
          --   never_show = { ".git" },
          -- },
          -- hijack_netrw_behavior = "open_default", -- "open_current"|"disabled"
          -- find_by_full_path_words = false,
          -- group_empty_dirs = false,
          -- bind_to_cwd = true,
          -- cwd_target = { sidebar = "tab", current = "window" },
        },

        buffers = {
          -- follow_current_file = { enabled = true },
          -- group_empty_dirs = true,
          -- show_unloaded = true,
        },

        git_status = {
          -- git_base = "main",
          -- window = { position = "float" },
        },

        -- event_handlers = {
        --   { event = "neo_tree_buffer_enter", handler = function(_) vim.opt_local.cursorline = true end },
        -- },
        -- commands = { },
      })

      -- auto open when launched on a directory
      -- if vim.fn.argc(-1) == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then vim.cmd("Neotree reveal") end
    end,
  },
})

