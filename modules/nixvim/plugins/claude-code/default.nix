{
  config,
  lib,
  pkgs,
  ...
}:
let
  luaConfig = # Lua
    ''
      require ("claude-code").setup({
        window = { position = "vertical"}
      })
    '';
in
{
  extraPackages = [
    pkgs.claude-code
  ];

  # TODO: upstream module
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
}
