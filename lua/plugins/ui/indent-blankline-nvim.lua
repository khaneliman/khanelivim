local hooks = require "ibl.hooks"

local macchiatoHighlight = {
  "MacchiatoRed",
  "MacchiatoYellow",
  "MacchiatoBlue",
  "MacchiatoPeach",
  "MacchiatoGreen",
  "MacchiatoMauve",
  "MacchiatoTeal",
}

-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "MacchiatoRed", { fg = "#ed8796" })
  vim.api.nvim_set_hl(0, "MacchiatoYellow", { fg = "#eed49f" })
  vim.api.nvim_set_hl(0, "MacchiatoBlue", { fg = "#8aadf4" })
  vim.api.nvim_set_hl(0, "MacchiatoPeach", { fg = "#f5a97f" })
  vim.api.nvim_set_hl(0, "MacchiatoGreen", { fg = "#a6da95" })
  vim.api.nvim_set_hl(0, "MacchiatoMauve", { fg = "#c6a0f6" })
  vim.api.nvim_set_hl(0, "MacchiatoTeal", { fg = "#8bd5ca" })
end)

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User AstroFile",
  opts = {
    indent = {
      char = "│",
      highlight = macchiatoHighlight,
    },
    scope = {
      enabled = false,
    },
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "Trouble", "lazy", "neo-tree" },
    },
    whitespace = {
      remove_blankline_trail = true,
    },
  },
}
