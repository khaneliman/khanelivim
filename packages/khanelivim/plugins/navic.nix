_: {

  # Shows the breadcrumb lsp node path in lualine
  plugins.navic = {
    enable = true;

    lsp = {
      autoAttach = true;
      preference = [
        "clangd"
        "tsserver"
      ];
    };
  };
}
