{
  config,
  lib,
  ...
}:
{
  plugins = {
    dap-view = {
      enable = !config.plugins.dap-ui.enable;

      settings = {
        winbar = {
          controls = {
            enabled = true;
          };
        };
      };
    };
  };

  keymaps = lib.optionals config.plugins.dap-view.enable [
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
}
