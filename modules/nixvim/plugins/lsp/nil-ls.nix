{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    lsp = {
      servers = {
        nil_ls = {
          enable = !config.plugins.lsp.servers.nixd.enable;
          settings = {
            formatting = {
              command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };
      };
    };
  };
}
