{
  config,
  ...
}:
{
  lsp.servers.rust_analyzer = {
    enable = !config.plugins.rustaceanvim.enable;
    # TODO: handle ourselves
    # installCargo = true;
    # installRustc = true;

    config.settings = {
      diagnostics = {
        enable = true;
        # experimental.enable = true;
        styleLints.enable = true;
      };

      files = {
        excludeDirs = [
          ".direnv"
          "rust/.direnv"
        ];
      };

      inlayHints = {
        bindingModeHints.enable = true;
        closureStyle = "rust_analyzer";
        closureReturnTypeHints.enable = "always";
        discriminantHints.enable = "always";
        expressionAdjustmentHints.enable = "always";
        implicitDrops.enable = true;
        lifetimeElisionHints.enable = "always";
        rangeExclusiveHints.enable = true;
      };

      procMacro = {
        enable = true;
      };
    };
  };
}
