return {
  {
    "echasnovski/mini.move",
    opts = {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = "˛",
        right = "ﬁ",
        down = "√",
        up = "ª",

        -- Move current line in Normal mode
        line_left = "˛",
        line_right = "ﬁ",
        line_down = "√",
        line_up = "ª",
      },
      keys = {
        { "ﬁ", mode = { "n", "v" } },
        { "ª", mode = { "n", "v" } },
        { "√", mode = { "n", "v" } },
        { "˛", mode = { "n", "v" } },
      },
    },
  },
  {
    "echasnovski/mini.surround",
    dependencies = {
      { "machakann/vim-sandwich", enabled = false },
      {
        "catppuccin/nvim",
        optional = true,
        opts = { integrations = { mini = true } },
      },
    },
    keys = {
      { "sa", desc = "Add surrounding", mode = { "n", "v" } },
      { "sd", desc = "Delete surrounding" },
      { "sf", desc = "Find right surrounding" },
      { "sF", desc = "Find left surrounding" },
      { "sh", desc = "Highlight surrounding" },
      { "sr", desc = "Replace surrounding" },
      { "sn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = { n_lines = 200 },
  },
}
