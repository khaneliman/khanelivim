-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        julials = { autostart = false },
      },
      features = {
        inlay_hints = true,
      },
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
    },
  },
}
