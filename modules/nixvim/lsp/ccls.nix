{ config, ... }:
{
  plugins = {
    lsp = {
      # ccls documentation
      # See: https://github.com/MaskRay/ccls
      servers = {
        ccls = {
          enable = config.khanelivim.lsp.cpp == "ccls";

          initOptions.compilationDatabaseDirectory = "build";
        };
      };
    };
  };
}
