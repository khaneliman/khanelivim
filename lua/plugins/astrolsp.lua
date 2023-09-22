-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        clangd = { settings = { capabilities = { offsetEncoding = "utf-8" } } },
        julials = { autostart = false },
        lua_ls = { settings = { Lua = { hint = { enable = true, arrayIndex = "Disable" } } } },
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
        taplo = { evenBetterToml = { schema = { catalogs = { "https://www.schemastore.org/api/json/catalog.json" } } } },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              completion = {
                postfix = {
                  enable = false,
                },
              },
            },
          },
        },
      },
      features = {
        inlay_hints = true,
      },
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      handlers = {
        rust_analyzer = false,
        tsserver = false,
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    init = function()
      local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Load clangd_extensions with clangd",
        callback = function(args)
          if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
            require "clangd_extensions"
            vim.api.nvim_del_augroup_by_id(augroup)
          end
        end,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = {
      "AstroNvim/astrolsp",
      opts = { handlers = { tsserver = false } },
    },
    opts = function()
      return require("astrocore").extend_tbl(require("astrolsp").lsp_opts "tsserver", {
        settings = {
          tsserver_path = require("mason-registry").get_package("typescript-language-server"):get_install_path()
            .. "/node_modules/typescript/lib/tsserver.js",
          tsserver_file_preferences = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          },
        },
      })
    end,
  },
}
