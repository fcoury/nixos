-- enable saving the state of plugins in the session
vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
-- setup neovim-project plugin
require("neovim-project").setup {
  projects = { -- define project roots
    "~/projects/*",
    "~/.config/*",
  },
}
