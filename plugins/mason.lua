return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = {
				"angularls",
				"bashls",
				"clangd",
				"csharp_ls",
				"cssls",
				"docker_compose_language_service",
				"dockerls",
				"grammarly",
				"html",
				"jsonls",
				"lemminx",
				"lua_ls",
				"marksman",
				"neocmake",
				"pyright",
				"nil_ls",
				"rnix",
				"sqlls",
				"tsserver",
				"yamlls",
			}
			return opts
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			opts.ensure_installed = {
				"black",
				"cbfmt",
				"clang_format",
				"csharpier",
				"eslint_d",
				"gitlint",
				"hadolint",
				"isort",
				"jq",
				"markdownlint",
				"rust-analyzer",
				"rustfmt",
				"shfmt",
				"stylua",
				"sql_formatter",
			}
			return opts
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			opts.ensure_installed = {
				"bash",
				"codelldb",
				"coreclr",
				"cppdbg",
				"firefox",
				"js",
				"node2",
				"python",
			}
			return opts
		end,
	},
}
