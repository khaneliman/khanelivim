return {
	"AstroNvim/astrocommunity",
	--
	-- Community Managed Plugins
	--
	-- UI tweaks
	{ import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
	{
		-- further customize the options set by the community
		"m4xshen/smartcolumn.nvim",
		opts = {
			colorcolumn = 120,
			disabled_filetypes = { "help" },
		},
	},
	{ import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
	{ import = "astrocommunity.bars-and-lines.heirline-mode-text-statusline" },
	-- Run commands in nvim
	{ import = "astrocommunity.code-runner.overseer-nvim" },
	-- Color picker/highlighter
	{ import = "astrocommunity.color.ccc-nvim" },
	{ import = "astrocommunity.color.twilight-nvim" },
	-- Theme
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			dim_inactive = { enabled = false, percentage = 0.25 },
			transparent_background = true, -- disables setting the background color.
		},
	},
	-- Code commenting
	{ import = "astrocommunity.comment.mini-comment" },
	{ import = "astrocommunity.debugging.nvim-bqf" },
	-- Elegant lsp virtual lines
	{ import = "astrocommunity.diagnostics.lsp_lines-nvim" },
	-- Diagnostic summary
	{ import = "astrocommunity.diagnostics.trouble-nvim" },
	-- Code formatting
	{ import = "astrocommunity.editing-support.mini-splitjoin" },
	-- Document generation
	{ import = "astrocommunity.editing-support.neogen" },
	-- Regex explanations
	{ import = "astrocommunity.editing-support.nvim-regexplainer" },
	-- Code refactoring
	{ import = "astrocommunity.editing-support.refactoring-nvim" },
	-- Sudo write
	{ import = "astrocommunity.editing-support.suda-vim" },
	-- Highlight todo comments
	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	-- Treesitter endwise
	{ import = "astrocommunity.editing-support.nvim-treesitter-endwise" },
	-- Improved Yank
	-- TODO: fix on nixos
	-- { import = "astrocommunity.editing-support.yanky-nvim" },
	-- Hide distractions
	{ import = "astrocommunity.editing-support.zen-mode-nvim" },
	-- Indent improvements
	{ import = "astrocommunity.indent.indent-blankline-nvim" },
	{ import = "astrocommunity.indent.mini-indentscope" },
	-- Markdown preview
	{ import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
	{ import = "astrocommunity.markdown-and-latex.peek-nvim" },
	-- Idle animation
	{ import = "astrocommunity.media.drop-nvim" },
	-- Development time analytics
	{ import = "astrocommunity.media.vim-wakatime" },
	-- Quick surround text
	{ import = "astrocommunity.motion.mini-surround" },
	{
		-- further customize the options set by the community
		"echasnovski/mini.surround",
		keys = {
			{ "s", desc = "Surround" },
		},
		opts = {
			mappings = {
				add = "s" .. "a",        -- Add surrounding in Normal and Visual modes
				delete = "s" .. "d",     -- Delete surrounding
				find = "s" .. "f",       -- Find surrounding (to the right)
				find_left = "s" .. "F",  -- Find surrounding (to the left)
				highlight = "s" .. "h",  -- Highlight surrounding
				replace = "s" .. "r",    -- Replace surrounding
				update_n_lines = "s" .. "n", -- Update `n_lines`
			},
		},
	},
	-- Quick jump
	{ import = "astrocommunity.motion.harpoon" },
	-- Org-like
	-- { import = "astrocommunity.note-taking/neorg" },
	-- Language Packs
	{ import = "astrocommunity.pack.angular" },
	{ import = "astrocommunity.pack.bash" },
	{ import = "astrocommunity.pack.cpp" },
	{ import = "astrocommunity.pack.cmake" },
	{ import = "astrocommunity.pack.docker" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.java" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.markdown" },
	-- { import = "astrocommunity.pack.nix" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.toml" },
	{ import = "astrocommunity.pack.typescript-all-in-one" },
	{ import = "astrocommunity.pack.yaml" },
	-- Project management
	{ import = "astrocommunity.project.nvim-spectre" },
	-- UI animation
	{ import = "astrocommunity.scrolling.mini-animate" },
	-- Syntax highlighting
	{ import = "astrocommunity.syntax.hlargs-nvim" },
	-- Test Runner
	{ import = "astrocommunity.test.neotest" },
	-- Tmux integration
	{ import = "astrocommunity.terminal-integration.vim-tmux-yank" },
	{ import = "astrocommunity.utility.neodim" },
	-- Notification system
	{ import = "astrocommunity.utility.noice-nvim" },
	-- Copilot
	-- { import = "astrocommunity.completion.copilot-lua" },
	-- { import = "astrocommunity.completion.copilot-lua-cmp" },
	-- {
	-- 	-- further customize the options set by the community
	-- 	"copilot.lua",
	-- 	opts = {
	-- 		suggestion = {
	-- 			keymap = {
	-- 				accept = "<C-l>",
	-- 				accept_word = false,
	-- 				accept_line = false,
	-- 				next = "<C-.>",
	-- 				prev = "<C-,>",
	-- 				dismiss = "<C/>",
	-- 			},
	-- 		},
	-- 	},
	-- },
}
