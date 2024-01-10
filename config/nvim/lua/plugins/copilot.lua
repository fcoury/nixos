require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<c-l>",
    },
  },
})

require("copilot_cmp").setup()
