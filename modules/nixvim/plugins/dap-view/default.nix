{
  config,
  lib,
  pkgs,
  ...
}:
let
  nvim-dap-view = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-dap-view";
    version = "2025-01-19";
    src = pkgs.fetchFromGitHub {
      owner = "igorlfs";
      repo = "nvim-dap-view";
      rev = "b807d96c3c5ceaeacde7bb482135365827341201";
      sha256 = "08m5mr9zs4drkilqc7albl8fvmknx84j8gzgbyml25ghqhffwddl";
    };
    dependencies = [ pkgs.vimPlugins.nvim-dap ];
    meta.homepage = "https://github.com/igorlfs/nvim-dap-view/";
  };
in
{
  # extraPlugins = [
  #   nvim-dap-view
  # ];

  keymaps =
    lib.optionals
      (
        (builtins.elem nvim-dap-view config.extraPlugins)
        && !config.plugins.dap.extensions.dap-ui.enable
        && !config.plugins.lz-n.enable
      )
      [
        {
          mode = "n";
          key = "<leader>du";
          action.__raw = ''
            function()
              require('dap.ext.vscode').load_launchjs(nil, {})
              require("dap-view").toggle()
            end
          '';
          options = {
            desc = "Toggle Debugger UI";
            silent = true;
          };
        }
      ];
}
