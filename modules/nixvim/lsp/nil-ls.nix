{
  config,
  lib,
  pkgs,
  ...
}:
{
  lsp.servers.nil_ls = {
    enable = !config.lsp.servers.nixd.enable;

    settings.settings = {
      formatting = {
        command = [ "${lib.getExe pkgs.nixfmt}" ];
      };
      nix = {
        flake = {
          autoArchive = true;
        };
      };
    };
  };
}
