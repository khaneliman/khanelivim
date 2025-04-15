{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.nvim-dap-view.enable = lib.mkEnableOption "nvim-dap-view" // {
    default = !config.plugins.dap-ui.enable;
  };

  config = lib.mkIf config.plugins.nvim-dap-view.enable {
    extraPlugins = [
      pkgs.vimPlugins.nvim-dap-view
    ];

    keymaps = [
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
      {
        mode = "n";
        key = "<leader>dw";
        action = "<CMD>DapViewWatch<CR>";
        options = {
          desc = "Add Watch";
        };
      }
    ];
  };
}
