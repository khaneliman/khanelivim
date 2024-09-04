{
  # Shows the breadcrumb lsp node path in lualine
  plugins.navic = {
    enable = true;

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
