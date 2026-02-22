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
    # helm-ls documentation
    # See: https://github.com/mrjosh/helm-ls
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
