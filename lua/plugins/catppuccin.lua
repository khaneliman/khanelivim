return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      dim_inactive = { enabled = false, percentage = 0.25 },
      integration_default = false,
      transparent_background = true, -- disables setting the background color.
      integrations = {
        aerial = true,
        cmp = true,
        dap = { enabled = true, enable_ui = true },
        gitsigns = true,
        headlines = true,
        markdown = true,
        mason = true,
        mini = true,
        native_lsp = { enabled = true, inlay_hints = { background = false } },
        neogit = true,
        neotree = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        sandwich = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = { enabled = true, style = "nvchad" },
        treesitter = true,
        which_key = true,
      },
      custom_highlights = {
        -- disable italics  for treesitter highlights
        TabLineFill = { link = "StatusLine" },
        LspInlayHint = { style = { "italic" } },
        ["@parameter"] = { style = {} },
        ["@type.builtin"] = { style = {} },
        ["@namespace"] = { style = {} },
        ["@text.uri"] = { style = { "underline" } },
        ["@tag.attribute"] = { style = {} },
        ["@tag.attribute.tsx"] = { style = {} },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },
}
