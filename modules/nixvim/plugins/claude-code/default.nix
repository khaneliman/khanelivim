{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: upstream module
  options.plugins.claude-code.enable = lib.mkEnableOption "claude-code" // {
    default = true;
  };

  config =
    let
      luaConfig = # Lua
        ''
          require ("claude-code").setup({
            window = { position = "vertical"}
          })
        '';
    in
    lib.mkIf config.plugins.claude-code.enable {
      extraPackages = [
        pkgs.claude-code
      ];

      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.claude-code-nvim;
          optional = config.plugins.lz-n.enable;
        }
      ];

      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "claude-code.nvim";
              cmd = [ "ClaudeCode" ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>ac";
          action = "<cmd>ClaudeCode<CR>";
          options = {
            desc = "Claude Code";
          };
        }
      ];
    };
}
