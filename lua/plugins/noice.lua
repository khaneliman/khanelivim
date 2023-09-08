local opts = {
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
    hover = { enabled = false },
    signature = { enabled = false, auto_open = { enabled = false } },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = false,
      ["cmp.entry.get_documentation"] = true,
    },
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
}

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = opts,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}
