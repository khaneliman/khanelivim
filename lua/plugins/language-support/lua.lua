local utils = require "astrocore"

return {
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true,
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "lua", "luap" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "lua_ls") end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require "null-ls"

      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "stylua", "luacheck" })

      if type(opts.sources) == "table" then
        vim.list_extend(opts.sources, {
          null_ls.builtins.formatting.stylua,
        })
      end
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    opts = {
      ensure_installed = { "lua" },
    },
  },
}
