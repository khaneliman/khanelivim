{
  plugins.smartcolumn = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      colorcolumn = "80";
      disabled_filetypes = [
        "ministarter"
        "checkhealth"
        "help"
        "lspinfo"
        "markdown"
        "neo-tree"
        "noice"
        "text"
      ];
      custom_colorcolumn = {
        go = [
          "100"
          "130"
        ];
        java = [
          "100"
          "140"
        ];
        nix = [
          "100"
          "120"
        ];
        rust = [
          "80"
          "100"
        ];
      };
      scope = "file";
    };
  };
}
