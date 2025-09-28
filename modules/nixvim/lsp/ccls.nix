{ config, ... }:
{
  plugins = {
    lsp = {
      servers = {
        ccls = {
          enable = config.khanelivim.lsp.cpp == "ccls";

          initOptions.compilationDatabaseDirectory = "build";
        };
      };
    };
  };
}
