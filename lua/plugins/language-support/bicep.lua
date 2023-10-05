local utils = require "astrocore"

return {
  -- bicep support
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
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
