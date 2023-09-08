return {
  "pmizio/typescript-tools.nvim",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  opts = function()
    return require("astrocore").extend_tbl(require("astrolsp").lsp_opts "tsserver", {
      settings = {
        expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused" },
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
}
