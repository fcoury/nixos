local config = require("nvim-treesitter.configs")
config.setup({
  sync_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  autotag = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<cr>",
      node_incremental = "<cr>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})

require("template-string").setup({})

-- fold
local opt = vim.opt
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
