{
  plugins = {
    lsp = {
      servers = {
        ccls = {
          enable = true;

          initOptions.compilationDatabaseDirectory = "build";
        };
      };
    };
  };
}
