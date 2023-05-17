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
				"intelephense",
				"jsonls",
				"lemminx",
				"lua_ls",
				"marksman",
				"neocmake",
				"pyright",
				"nil_ls",
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
				"sql_formatter",
			}
			opts.setup_handlers = {
				prettierd = function()
					require("null-ls").register(require("null-ls").builtins.formatting.prettierd.with({
						condition = function(utils)
							return utils.root_has_file("package.json")
									or utils.root_has_file(".prettierrc")
									or utils.root_has_file(".prettierrc.json")
									or utils.root_has_file(".prettierrc.js")
						end,
					}))
				end,
				eslint_d = function()
					require("null-ls").register(require("null-ls").builtins.diagnostics.eslint_d.with({
						condition = function(utils)
							return utils.root_has_file("package.json")
									or utils.root_has_file(".eslintrc.json")
									or utils.root_has_file(".eslintrc.js")
						end,
					}))
				end,
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
