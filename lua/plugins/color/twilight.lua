return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<leader>uT"] = { "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
        },
      },
    },
  },
  {
    "folke/twilight.nvim",
    cmd = {
      "Twilight",
      "TwilightEnable",
      "TwilightDisable",
    },
  },
}
