{
  config,
  lib,
  ...
}:
{
  plugins = {
    dap-view = {
      # dap-view.nvim documentation
      # See: https://github.com/igorlfs/nvim-dap-view
      enable = config.khanelivim.debugging.ui == "dap-view";

      settings = {
        winbar = {
          controls = {
            enabled = true;
          };
        };
      };
    };
  };

  keymaps = lib.optionals (config.khanelivim.debugging.ui == "dap-view") [
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
