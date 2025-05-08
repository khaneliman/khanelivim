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

  config =
    let
      luaConfig = # Lua
        ''
          require("dap-view").setup({
            winbar = {
              controls = {
                enabled = true,
              }
            }
          })
        '';
    in
    lib.mkIf config.plugins.nvim-dap-view.enable {
      extraConfigLua = luaConfig;

      extraPlugins = [
        # TODO: remove once upstreamed
        (pkgs.vimPlugins.nvim-dap-view.overrideAttrs {
          version = "2025-05-01";
          src = pkgs.fetchFromGitHub {
            owner = "igorlfs";
            repo = "nvim-dap-view";
            rev = "2d68f421fbcf495a5127486bdd5322adf11efe68";
            sha256 = "0bbrzzvzqjz2cgiiypmhgkwxazsrfnnbicwiklhx9b7xdk8kqxkd";
          };
        })
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
