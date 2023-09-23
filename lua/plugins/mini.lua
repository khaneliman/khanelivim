return {
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    cond = not vim.g.neovide,
    -- enabled = false,
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { "Up", "Down" } do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require "mini.animate"
      return {
        resize = {
          timing = animate.gen_timing.linear { duration = 100, unit = "total" },
        },
        scroll = {
          timing = animate.gen_timing.linear { duration = 150, unit = "total" },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          },
        },
        cursor = {
          timing = animate.gen_timing.linear { duration = 80, unit = "total" },
        },
      }
    end,
  },
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
  { "numToStr/Comment.nvim", enabled = false },
  {
    "echasnovski/mini.comment",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = "User AstroFile",
    opts = {
      hooks = {
        pre = function() require("ts_context_commentstring.internal").update_commentstring {} end,
      },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    event = "User AstroFile",
    opts = {},
    dependencies = {},
  },
  {
    "catppuccin/nvim",
    optional = true,
    opts = { integrations = { mini = true } },
  },
}
