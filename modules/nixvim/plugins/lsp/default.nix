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

      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>lH" = "open_float";
        };

        lspBuf =
          lib.optionalAttrs (!config.plugins.conform-nvim.enable) { "<leader>lf" = "format"; }
          // lib.optionalAttrs (!config.plugins.fzf-lua.enable) { "<leader>la" = "code_action"; }
          //
            lib.optionalAttrs
              (
                (
                  !config.plugins.snacks.enable
                  || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
                )
                && !config.plugins.fzf-lua.enable
              )
              {
                "<leader>ld" = "definition";
                "<leader>lt" = "type_definition";
              };
      };
    };
  };
}
