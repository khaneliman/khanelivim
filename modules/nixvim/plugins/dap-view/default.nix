{
  config,
  lib,
  pkgs,
  ...
}:
{
  # extraPlugins = [
  #   pkgs.vimPlugins.nvim-dap-view
  # ];

  keymaps =
    lib.optionals
      ((builtins.elem pkgs.vimPlugins.nvim-dap-view config.extraPlugins) && !config.plugins.dap-ui.enable)
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
