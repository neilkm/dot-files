local map = vim.keymap.set

map("n", "<leader>e", "<cmd>Neotree toggle current reveal_force_cwd<cr>", { desc = "Toggle Neo-tree in current window" })
map("n", "<leader>t", function()
  local current_tab = vim.api.nvim_get_current_tabpage()

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.cmd("botright split")
  vim.cmd("resize " .. math.max(6, math.floor(vim.o.lines * 0.15)))
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Focus terminal split or open one at the bottom" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })
map("n", "<C-Left>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-Down>", "<C-w>j", { desc = "Focus lower split" })
map("n", "<C-Up>", "<C-w>k", { desc = "Focus upper split" })
map("n", "<C-Right>", "<C-w>l", { desc = "Focus right split" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })
map("n", "<leader>gc", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle line comment" })
map("v", "<leader>gc", function()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle line comment" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("t", "<C-Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
