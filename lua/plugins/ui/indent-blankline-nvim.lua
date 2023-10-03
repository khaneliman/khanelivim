vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" }
vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_show_current_context = false

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "User AstroFile",
  opts = {},
}
