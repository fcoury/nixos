vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end)

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end)

vim.keymap.set("n", "<leader>t", "<cmd>TodoTelescope<cr>")

require("todo-comments").setup()
