{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    dap-view = {
      enable = !config.plugins.dap-ui.enable;

      # TODO: remove once updated upstream
      package = pkgs.vimPlugins.nvim-dap-view.overrideAttrs {
        version = "2025-05-01";
        src = pkgs.fetchFromGitHub {
          owner = "igorlfs";
          repo = "nvim-dap-view";
          rev = "2d68f421fbcf495a5127486bdd5322adf11efe68";
          sha256 = "0bbrzzvzqjz2cgiiypmhgkwxazsrfnnbicwiklhx9b7xdk8kqxkd";
        };
      };

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
