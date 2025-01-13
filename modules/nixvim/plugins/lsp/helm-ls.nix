{ config, lib, ... }:
{
  autoCmd = [
    (lib.mkIf config.plugins.lsp.servers.helm_ls.enable {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    })
  ];

  plugins = {
    helm = {
      inherit (config.plugins.lsp) enable;
    };
    lsp = {
      servers = {
        helm_ls.enable = true;
      };
    };
  };
}
