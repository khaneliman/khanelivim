return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      format = {
        spinner = {
          name = "mine",
          hl = "Constant",
        },
      },
      lsp = {
        progress = {
          enabled = false,
          format = {
            { "{data.progress.percentage} ", hl_group = "Comment" },
            { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
            { "{data.progress.title} ", hl_group = "Comment" },
          },
          format_done = {},
        },
        hover = {
          enabled = true,
          silent = false, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = utils.is_available "inc-rename.nvim", -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      cmdline = {
        format = {
          filter = { pattern = "^:%s*!", icon = " ", ft = "sh" },
          IncRename = {
            pattern = "^:%s*IncRename%s+",
            icon = " ",
            conceal = true,
            opts = {
              -- relative = "cursor",
              -- size = { min_width = 20 },
              -- position = { row = -3, col = 0 },
              buf_options = { filetype = "text" },
            },
          },
        },
      },
      popupmenu = {
        enabled = true,
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
          view = "mini",
        },
        {
          view = "cmdline_output",
          filter = { cmdline = "^:", min_height = 5 },
          -- BUG: will be fixed after https://github.com/neovim/neovim/issues/21044 gets merged
        },
        {
          filter = { event = "msg_show", kind = "search_count" },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "; before #",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "; after #",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = " lines, ",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "go up one level",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "yanked",
          },
          opts = { skip = true },
        },
        {
          filter = { find = "No active Snippet" },
          opts = { skip = true },
        },
        {
          filter = { find = "waiting for cargo metadata" },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.bottom then opts.bottom = {} end
      table.insert(opts.bottom, {
        ft = "noice",
        size = { height = 0.4 },
        filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
      })
    end,
  },
  {
    "catppuccin/nvim",
    optional = true,
    opts = { integrations = { noice = true } },
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     if opts.ensure_installed ~= "all" then
  --       opts.ensure_installed =
  --         utils.list_insert_unique(opts.ensure_installed, { "bash", "markdown", "markdown_inline", "regex", "vim" })
  --     end
  --   end,
  -- },
  { "rcarriga/nvim-notify", opts = {
    background_colour = "#24273a",
    timeout = 0,
  } },
}
