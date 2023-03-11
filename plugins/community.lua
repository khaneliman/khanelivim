return {
	"AstroNvim/astrocommunity",
	-- Plugins
	{ import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
	{ import = "astrocommunity.code-runner.overseer-nvim" },
	{ import = "astrocommunity.color.ccc-nvim" },
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.comment.mini-comment" },
	{ import = "astrocommunity.debugging.nvim-bqf" },
	{ import = "astrocommunity.diagnostics.lsp_lines-nvim" },
	{ import = "astrocommunity.diagnostics.trouble-nvim" },
	{ import = "astrocommunity.editing-support.mini-splitjoin" },
	{ import = "astrocommunity.editing-support.neogen" },
	{ import = "astrocommunity.editing-support.nvim-regexplainer" },
	{ import = "astrocommunity.editing-support.refactoring-nvim" },
	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	{ import = "astrocommunity.editing-support.zen-mode-nvim" },
	{ import = "astrocommunity.indent.indent-blankline-nvim" },
	{ import = "astrocommunity.indent.mini-indentscope" },
	{ import = "astrocommunity.markdown-and-latex.glow-nvim" },
	{ import = "astrocommunity.media.drop-nvim" },
	{ import = "astrocommunity.media.presence-nvim" },
	{ import = "astrocommunity.media.vim-wakatime" },
	{ import = "astrocommunity.motion.mini-surround" },
	{ import = "astrocommunity.note-taking/neorg" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.project.neoconf-nvim" },
	{ import = "astrocommunity.project.nvim-spectre" },
	{ import = "astrocommunity.scrolling.mini-animate" },
	{ import = "astrocommunity.syntax.hlargs-nvim" },
	{ import = "astrocommunity.test.neotest" },
	{ import = "astrocommunity.utility.neodim" },
	{ import = "astrocommunity.utility.noice-nvim" },
	{
		-- further customize the options set by the community
		"catppuccin",
		opts = {
			integrations = {
				sandwich = true,
				noice = true,
				mini = true,
				leap = true,
				markdown = true,
				neotest = true,
				cmp = true,
				overseer = true,
				lsp_trouble = true,
				ts_rainbow2 = true,
			},
		},
	},
	{
		"echasnovski/mini.surround",
		keys = {
			{ 's', desc = "Surround" },
		},
		opts = {
			mappings = {
				add = 's' .. "a",        -- Add surrounding in Normal and Visual modes
				delete = 's' .. "d",     -- Delete surrounding
				find = 's' .. "f",       -- Find surrounding (to the right)
				find_left = 's' .. "F",  -- Find surrounding (to the left)
				highlight = 's' .. "h",  -- Highlight surrounding
				replace = 's' .. "r",    -- Replace surrounding
				update_n_lines = 's' .. "n", -- Update `n_lines`
			},
		},
	},
	{
		"m4xshen/smartcolumn.nvim",
		opts = {
			colorcolumn = 120,
			disabled_filetypes = { "help" },
		},
	},
}
