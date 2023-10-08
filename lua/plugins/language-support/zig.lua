local utils = require "astrocore"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "zig" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "zls") end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "stylua", "luacheck" })
    end,
  },
  {
    "NTBBloodbath/zig-tools.nvim",
    -- Load zig-tools.nvim only in Zig buffers
    ft = { "zig" },
    opts = {},
    dependencies = {
      {
        "akinsho/toggleterm.nvim",
      },
      {
        "nvim-lua/plenary.nvim",
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    opts = {
      ensure_installed = { "zig" },
    },
  },
}
