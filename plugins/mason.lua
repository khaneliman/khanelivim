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
				"dockerls",
				"eslint",
				"grammarly",
				"html",
				"intelephense",
				"jsonls",
				"lemminx",
				"marksman",
				"neocmake",
				"omnisharp",
				"pyright",
				"sqls",
				"lua_ls",
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
				"prettierd",
				"rust-analyzer",
				"rustfmt",
				"shellcheck",
				"shfmt",
				"sql_formatter",
				"stylua",
			}
			opts.setup_handlers = {
				prettier = function()
					require("null-ls").register(require("null-ls").builtins.formatting.prettier.with({
						condition = function(utils)
							return utils.root_has_file("package.json")
								or utils.root_has_file(".prettierrc")
								or utils.root_has_file(".prettierrc.json")
								or utils.root_has_file(".prettierrc.js")
						end,
					}))
				end,
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
				"node2",
				"python",
				"js",
			}
			return opts
		end,
	},
}
