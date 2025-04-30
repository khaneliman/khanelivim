{
  config,
  lib,
  ...
}:
{
  imports = [
    ./ccls.nix
    ./helm-ls.nix
    ./nil-ls.nix
    ./nixd.nix
    ./rust-analyzer.nix
    ./typos-lsp.nix
  ];

  # TODO: migrate to mkneovimplugin
  extraConfigLuaPre = ''
    require('lspconfig.ui.windows').default_options = {
      border = "rounded"
    }
  '';

  plugins = {
    lsp-format.enable = !config.plugins.conform-nvim.enable && config.plugins.lsp.enable;
    lsp-signature.enable = config.plugins.lsp.enable;

    lsp = {
      enable = true;

    };
  };
}
