{
  config,
  ...
}:
{
  # rust-analyzer documentation
  # See: https://rust-analyzer.github.io/
  lsp.servers.rust_analyzer = {
    enable = config.khanelivim.lsp.rust == "rust-analyzer";
    # TODO: handle ourselves
    # installCargo = true;
    # installRustc = true;

    config.settings = {
      cargo = {
        buildScripts.enable = true;
        features = "all";
      };

      diagnostics = {
        enable = true;
        # experimental.enable = true;
        styleLints.enable = true;
      };

      checkOnSave = true;
      check = {
        command = "clippy";
        features = "all";
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

      rustc.source = "discover";
    };
  };
}
