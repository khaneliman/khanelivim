-- Example customization of mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
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
        "nil_ls",
        "pyright",
        "sqlls",
        "tsserver",
        "yamlls",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
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
        "shfmt",
        "sql_formatter",
        "stylua",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "bash",
        "codelldb",
        "coreclr",
        "cppdbg",
        "firefox",
        "js",
        "node2",
        "python",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
    },
  },
}
