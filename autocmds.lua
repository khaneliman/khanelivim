-- only show tabline when more than one tab
vim.api.nvim_create_autocmd("User", {
	desc = "Hide tabline when only one buffer and one tab",
	pattern = "AstroBufsUpdated",
	group = vim.api.nvim_create_augroup("autohide_tabline", { clear = true }),
	callback = function()
		local new_showtabline = #vim.t.bufs > 1 and 2 or 1
		if new_showtabline ~= vim.opt.showtabline:get() then
			vim.opt.showtabline = new_showtabline
		end
	end,
})
-- load parameters for neovide
if vim.g.neovide then
	vim.g.neovide_transparency = 0.95
	vim.g.neovide_input_macos_alt_is_meta = true
	vim.cmd([[set guifont=Liga SFMono Nerd Font,Symbols\ Nerd\ Font]])
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.transparency = 0.95
end

-- Enable spell and wrap for markdown and gitcommit
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable wrap and spell for text like documents",
	pattern = { "gitcommit", "markdown", "text", "plaintex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})
