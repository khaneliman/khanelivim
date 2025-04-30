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

  extraConfigLuaPre =
    lib.mkIf config.plugins.lspconfig.enable # Lua
      ''
        require('lspconfig.ui.windows').default_options = {
          border = "rounded"
        }
      '';

  plugins = {
    lspconfig.enable = true;
    lsp-format.enable = !config.plugins.conform-nvim.enable && config.plugins.lsp.enable;
    lsp-signature.enable = config.plugins.lsp.enable;
  };
}
