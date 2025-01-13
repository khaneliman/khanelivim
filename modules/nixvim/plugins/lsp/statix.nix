{
  plugins = {
    lsp = {
      servers = {
        statix = {
          enable = true;
          cmd = [
            "statix"
            "check"
            "-s"
          ];
        };
      };
    };
  };
}
