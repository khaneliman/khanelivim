local utils = require "astrocore"

return {
  -- bicep support
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "bicep" })
      end
    end,
    dependencies = {
      {
        "amaanq/tree-sitter-bicep",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "bicep") end,
  },
  {
    "carlsmedstad/vim-bicep",
    ft = "bicep",
  },
}
