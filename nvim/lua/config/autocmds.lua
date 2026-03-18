vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 120 })
  end,
})

local file_watch_group = vim.api.nvim_create_augroup("file-watch", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  desc = "Reload files changed outside of Neovim",
  group = file_watch_group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" or vim.fn.mode() ~= "n" then
      return
    end

    vim.cmd.checktime()
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  desc = "Close buffers whose files were deleted",
  group = file_watch_group,
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and not vim.bo[buf].modified then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" and vim.fn.filereadable(name) == 0 then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end)
        end
      end
    end
  end,
})
