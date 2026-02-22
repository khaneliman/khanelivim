{
  plugins.smartcolumn = {
    # smartcolumn.nvim documentation
    # See: https://github.com/m4xshen/smartcolumn.nvim
    enable = true;

    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];

    settings = {
      colorcolumn = "80";
      disabled_filetypes = [
        "dashboard"
        "snacks_dashboard"
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
