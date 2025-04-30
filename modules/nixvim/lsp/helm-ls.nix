{ config, lib, ... }:
{
  autoCmd = [
    (lib.mkIf config.lsp.servers.helm_ls.enable {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    })
  ];

  lsp = {
    servers = {
      helm_ls.enable = true;
    };
  };

  plugins = {
    helm = {
      inherit (config.plugins.lsp) enable;
    };
  };
}
