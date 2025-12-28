{
  # Shows the breadcrumb lsp node path in lualine
  plugins.navic = {
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
