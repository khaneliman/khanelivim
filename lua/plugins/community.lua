return {
  "AstroNvim/astrocommunity",
  {
    -- further customize the options set by the community
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help" },
    },
  },
  {
    -- further customize the options set by the community
    "echasnovski/mini.surround",
    keys = {
      { "s", desc = "Surround" },
    },
    opts = {
      mappings = {
        add = "s" .. "a", -- Add surrounding in Normal and Visual modes
        delete = "s" .. "d", -- Delete surrounding
        find = "s" .. "f", -- Find surrounding (to the right)
        find_left = "s" .. "F", -- Find surrounding (to the left)
        highlight = "s" .. "h", -- Highlight surrounding
        replace = "s" .. "r", -- Replace surrounding
        update_n_lines = "s" .. "n", -- Update `n_lines`
      },
    },
  },
}
