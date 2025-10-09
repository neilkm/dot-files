-- ~/.config/nvim/init.lua

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  {
    "folke/neodev.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional but nice
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  },
})

-- enable neodev
require("neodev").setup({})

-- basic keymap for Neo-tree
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

