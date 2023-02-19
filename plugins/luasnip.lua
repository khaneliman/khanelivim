return {
	"L3MON4D3/LuaSnip",
	config = function(plugin, opts)
		require("plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
		-- add more custom luasnip configuration such as filetype extend or custom snippets
		local luasnip = require("luasnip")
		luasnip.filetype_extend("javascript", { "javascriptreact" })
		-- include custom snippets
		require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/user/snippets" } })
	end,
}
