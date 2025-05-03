{
  config,
  lib,
  ...
}:
{
  extraConfigLuaPre =
    lib.mkIf config.plugins.lspconfig.enable # Lua
      ''
        require('lspconfig.ui.windows').default_options = {
          border = "rounded"
        }
      '';

  plugins = {
    lspconfig.enable = true;
  };
}
