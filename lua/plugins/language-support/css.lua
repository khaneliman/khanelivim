local utils = require "astrocore"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "css", "scss" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "cssls", "cssmodules_ls", "emmet_ls" })
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    opts = {
      ensure_installed = { "css" },
    },
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        cssmodules_ls = {
          capabilities = {
            definitionProvider = false,
          },
        },
      },
    },
  },
}
