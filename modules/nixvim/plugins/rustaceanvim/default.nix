{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.rustaceanvim.enable (
    with pkgs.vimPlugins;
    [
      # Needed for RustPlay
      webapi-vim
    ]
  );

  plugins = {
    rustaceanvim = {
      enable = true;
      settings = {
        dap = {
          adapter = {
            command = lib.getExe' pkgs.lldb "lldb-dap";
            type = "executable";
          };
          autoloadConfigurations = true;
        };

        server = {
          default_settings = {
            rust-analyzer = {
              cargo = {
                buildScripts.enable = true;
                features = "all";
              };

              diagnostics = {
                enable = true;
                styleLints.enable = true;
              };

              checkOnSave = true;
              check = {
                command = "clippy";
                features = "all";
              };

              files = {
                excludeDirs = [
                  ".cargo"
                  ".direnv"
                  ".git"
                  "node_modules"
                  "target"
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
        };
        tools.enable_clippy = true;
      };
    };
  };
}
