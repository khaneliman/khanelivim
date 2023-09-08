local prefix = "<Leader>x"
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          [prefix] = { desc = "󰒡 Trouble" },
          [prefix .. "x"] = { "<Cmd>TroubleToggle document_diagnostics<CR>", desc = "Document Diagnostics (Trouble)" },
          [prefix .. "X"] = { "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace Diagnostics (Trouble)" },
          [prefix .. "l"] = { "<Cmd>TroubleToggle loclist<CR>", desc = "Location List (Trouble)" },
          [prefix .. "q"] = { "<Cmd>TroubleToggle quickfix<CR>", desc = "Quickfix List (Trouble)" },
        },
      },
    },
  },
  opts = {
    use_diagnostic_signs = true,
    action_keys = {
      close = { "q", "<Esc>" },
      cancel = "<C-e>",
    },
  },
}
