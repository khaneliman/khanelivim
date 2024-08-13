_: {
  plugins = {
    firenvim = {
      enable = true;

      settings = {
        localSettings = {
          ".*" = {
            cmdline = "neovim";
            content = "text";
            priority = 0;
            selector = "textarea";
            takeover = "always";
          };
        };
      };
    };
  };
}
