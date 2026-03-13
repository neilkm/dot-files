vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      window = {
        width = function()
          return math.floor(vim.o.columns * 0.2)
        end,
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = vim.fn.readfile(vim.fn.stdpath("config") .. "/ascii-art.txt")
      dashboard.section.header.opts.position = "center"

     dashboard.section.buttons.val = {
       dashboard.button("e", "New file", ":ene <BAR> startinsert <CR>"),
       dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
       dashboard.button("g", "Live grep", ":Telescope live_grep<CR>"),
       dashboard.button("q", "Quit", ":qa<CR>"),
      }

      local footer_path = vim.fn.stdpath("config") .. "/footer.txt"
      if vim.uv.fs_stat(footer_path) then
        dashboard.section.footer.val = table.concat(vim.fn.readfile(footer_path), "\n")
      else
        dashboard.section.footer.val = "(not installed yet)"
      end
      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}, {
  checker = { enabled = false },
  change_detection = { notify = false },
})
