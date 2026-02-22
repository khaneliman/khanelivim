{
  # Shows the breadcrumb lsp node path in lualine
  plugins.navic = {
    # nvim-navic documentation
    # See: https://github.com/SmiteshP/nvim-navic
    enable = true;

    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];

    settings = {
      lsp = {
        auto_attach = true;
        preference = [
          "clangd"
          "tsserver"
        ];
      };
    };
  };
}
