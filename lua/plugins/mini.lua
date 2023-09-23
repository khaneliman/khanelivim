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
  {
    "echasnovski/mini.operators",
    keys = {
      { "<leader>oe", desc = "Evaluate" },
      { "<leader>ox", desc = "Exchange" },
      { "<leader>om", desc = "Multiply" },
      { "<leader>or", desc = "Replace" },
      { "<leader>os", desc = "Sort" },
    },
    config = function()
      local minioperators = require "mini.operators"

      minioperators.setup {
        evaluate = { prefix = "<leader>oe" },
        exchange = { prefix = "<leader>ox" },
        multiply = { prefix = "<leader>om" },
        replace = { prefix = "<leader>or" },
        sort = {
          prefix = "<leader>os",
          func = function(content)
            local opts = nil
            if content.submode == "v" then
              local delimiter = vim.fn.input "Sort delimiter: "
              -- TODO: Word sorting? https://github.com/echasnovski/mini.nvim/issues/439#issuecomment-1681408764
              if #delimiter > 0 then
                opts = {
                  split_patterns = { "%s*" .. vim.pesc(delimiter) .. "%s*" },
                }
              end
            end
            return minioperators.default_sort_func(content, opts)
          end,
        },
      }
    end,
  },
}
