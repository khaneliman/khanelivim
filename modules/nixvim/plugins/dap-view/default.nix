{
  config,
  lib,
  ...
}:
{
  plugins = {
    dap-view = {
      enable = config.khanelivim.editor.debugUI == "dap-view";

      settings = {
        winbar = {
          controls = {
            enabled = true;
          };
        };
      };
    };
  };

  keymaps = lib.optionals (config.khanelivim.editor.debugUI == "dap-view") [
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
