return {
  "folke/todo-comments.nvim",
  event = "User AstroFile",
  cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>fT"] = { "<Cmd>TodoTelescope<CR>", desc = "Find TODOs" },
          ["<Leader>xT"] = { "<Cmd>TodoTrouble<CR>", desc = "TODOs (Trouble)" },
        },
      },
    },
  },
  opts = {},
}
