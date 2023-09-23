local cmp = require "cmp"
local utils = require "astrocore"
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-calc",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",
      "hrsh7th/cmp-cmdline",
      "mtoohey31/cmp-fish",
      "tamago324/cmp-zsh",
      "petertriho/cmp-git",
      "David-Kunz/cmp-npm",
    },
    config = function(_, opts)
      -- require("plugins.cmp")(plugin, opts) -- include the default astronvim config that calls the setup call
      opts.sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "omni", priority = 800 },
        { name = "luasnip", priority = 750 },
        { name = "emoji", priority = 700 },
        { name = "calc", priority = 650 },
        { name = "path", priority = 500 },
        { name = "fish", priority = 300 },
        { name = "zsh", priority = 300 },
        { name = "npm", priority = 300 },
        { name = "git", priority = 300 },
        { name = "buffer", priority = 250 },
        { name = "nerdfont", priority = 200 },
        { name = "cmdline", priority = 200 },
      }
      -- run cmp setup
      cmp.setup(opts)

      -- configure `cmp-cmdline` as described in their repo: https://github.com/hrsh7th/cmp-cmdline#setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      -- return opts
    end,
  },
  {
    "mtoohey31/cmp-fish",
    dependencies = { "hrsh7th/nvim-cmp" },
    -- config = function()
    -- 	-- Add bindings which show up as group name
    -- 	local cmp = require("cmp")
    -- 	local config = cmp.get_config()
    -- 	table.insert(config.sources, {
    -- 		{ name = "fish" },
    -- 	})
    -- 	cmp.setup(config)
    -- end,
    ft = "fish",
  },
  {
    "tamago324/cmp-zsh",
    dependencies = { "hrsh7th/nvim-cmp" },
    -- config = function()
    -- 	-- Add bindings which show up as group name
    -- 	local cmp = require("cmp")
    -- 	local config = cmp.get_config()
    -- 	table.insert(config.sources, {
    -- 		{ name = "zsh" },
    -- 	})
    -- 	cmp.setup(config)
    -- end,
    ft = "zsh",
  },
  {
    "petertriho/cmp-git",
    dependencies = { "hrsh7th/nvim-cmp" },
    -- config = function()
    -- 	-- Add bindings which show up as group name
    -- 	local cmp = require("cmp")
    -- 	local config = cmp.get_config()
    -- 	table.insert(config.sources, {
    -- 		{ name = "git" },
    -- 	})
    -- 	cmp.setup(config)
    -- end,
    ft = "gitcommit",
  },
  {
    "David-Kunz/cmp-npm",
    dependencies = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
    -- config = function()
    -- 	-- Add bindings which show up as group name
    -- 	require("cmp-npm").setup({})
    -- 	local cmp = require("cmp")
    -- 	local config = cmp.get_config()
    -- 	table.insert(config.sources, {
    -- 		{ name = "npm", keyword_length = 4 },
    -- 	})
    -- 	cmp.setup(config)
    -- end,
    ft = "json",
  },
}
