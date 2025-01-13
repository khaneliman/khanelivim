{
  plugins = {
    lsp = {
      servers = {
        typos_lsp = {
          enable = true;
          extraOptions = {
            init_options = {
              diagnosticSeverity = "Hint";
            };
          };
        };
      };
    };
  };
}
