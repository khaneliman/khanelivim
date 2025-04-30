{
  config,
  lib,
  pkgs,
  ...
}:
{
  lsp.servers.nil_ls = {
    enable = !config.lsp.servers.nixd.enable;

    config.settings = {
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
}
