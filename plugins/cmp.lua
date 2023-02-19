return {
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			-- require("plugins.cmp")(plugin, opts) -- include the default astronvim config that calls the setup call
			opts.sources = {
				opts.sources,
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "omni",     priority = 800 },
				{ name = "luasnip",  priority = 750 },
				{ name = "emoji",    priority = 700 },
				{ name = "calc",     priority = 650 },
				{ name = "path",     priority = 500 },
				{ name = "fish",     priority = 300 },
				{ name = "npm",      priority = 300 },
				{ name = "git",      priority = 300 },
				{ name = "buffer",   priority = 250 },
			}
			return opts
		end,
	},
	{
		"hrsh7th/cmp-calc",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter",
		-- config = function()
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "calc" },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
	},
	{
		"hrsh7th/cmp-emoji",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter",
		-- config = function()
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "emoji" },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
	},
	{
		"chrisgrieser/cmp-nerdfont",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		-- config = function(plugin, opts)
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "nerdfont" },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
	},
	{
		"mtoohey31/cmp-fish",
		dependencies = { "hrsh7th/nvim-cmp" },
		-- config = function()
		-- 	-- Add bindings which show up as group name
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "fish" },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
		ft = "fish",
	},
	{
		"tamago324/cmp-zsh",
		dependencies = { "hrsh7th/nvim-cmp" },
		-- config = function()
		-- 	-- Add bindings which show up as group name
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "zsh" },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
		ft = "zsh",
	},
	{
		"petertriho/cmp-git",
		dependencies = { "hrsh7th/nvim-cmp" },
		-- config = function()
		-- 	-- Add bindings which show up as group name
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "git" },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
		ft = "gitcommit",
	},
	{
		"David-Kunz/cmp-npm",
		dependencies = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
		-- config = function()
		-- 	-- Add bindings which show up as group name
		-- 	require("cmp-npm").setup({})
		-- 	local cmp = require("cmp")
		-- 	local config = cmp.get_config()
		-- 	table.insert(config.sources, {
		-- 		{ name = "npm", keyword_length = 4 },
		-- 	})
		-- 	cmp.setup(config)
		-- end,
		ft = "json",
	},
}
