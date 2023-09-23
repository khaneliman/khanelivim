local prefix = "<Leader>x"
local maps = { n = {}, x = {} }

local icon = vim.g.icons_enabled and "󰒡  " or ""
maps.n[prefix] = { desc = icon .. "Trouble" }

return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          [prefix .. "x"] = { "<Cmd>TroubleToggle document_diagnostics<CR>", desc = "Document Diagnostics (Trouble)" },
          [prefix .. "X"] = { "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace Diagnostics (Trouble)" },
          [prefix .. "l"] = { "<Cmd>TroubleToggle loclist<CR>", desc = "Location List (Trouble)" },
          [prefix .. "q"] = { "<Cmd>TroubleToggle quickfix<CR>", desc = "Quickfix List (Trouble)" },
        },
      },
    },
    {
      "folke/edgy.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.bottom then opts.bottom = {} end
        table.insert(opts.bottom, "Trouble")
      end,
    },
    {
      "catppuccin/nvim",
      optional = true,
      opts = { integrations = { lsp_trouble = true } },
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
