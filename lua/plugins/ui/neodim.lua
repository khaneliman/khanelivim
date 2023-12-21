return {
  "zbirenbaum/neodim",
  event = "LspAttach",
  opts = {
    refresh_delay = 75,
    alpha = 0.75,
    update_in_insert = {
      enable = true,
      delay = 100,
    },
    blend_color = "#24273a",
    hide = {
      underline = true,
      virtual_text = true,
      signs = true,
    },
    regex = {
      "[uU]nused",
      "[nN]ever [rR]ead",
      "[nN]ot [rR]ead",
    },
    priority = 128,
    disable = {},
  },
}
