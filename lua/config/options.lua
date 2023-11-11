-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/options.lua
-- Add any additional options here

-- vim.opt.relativenumber = true -- sets vim.opt.relativenumber
-- vim.opt.number = true -- sets vim.opt.number
-- vim.opt.spell = false -- sets vim.opt.spell
-- vim.opt.signcolumn = "auto" -- sets vim.opt.signcolumn to auto
-- vim.opt.wrap = false -- sets vim.opt.wrap

-- vim.g.mapleader = " " -- sets vim.g.mapleader
--
vim.g.icons_enabled = true
-- vim.lsp.set_log_level "debug"

-- Neovide variables
if vim.g.neovide then
  vim.o.guifont = "Monaspace Krypton:h16,SF_PRO_TEXT:h16"
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_input_use_logo = true -- true on macOS
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
end
