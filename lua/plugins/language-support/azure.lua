local utils = require "astrocore"

return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "azure_pipelines_ls")
    end,
  },
}
