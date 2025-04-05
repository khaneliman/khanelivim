{
  config,
  lib,
  pkgs,
  ...
}:
let
  pluginEnabled = builtins.elem pkgs.vimPlugins.visual-whitespace-nvim config.extraPlugins;
in
{
  extraConfigLua =
    lib.mkIf pluginEnabled # Lua
      ''
        require("visual-whitespace").setup({
          enabled = false
        })
      '';

  extraPlugins = with pkgs.vimPlugins; [ visual-whitespace-nvim ];

  keymaps = lib.mkIf pluginEnabled [
    {
      key = "<leader>uW";
      action = ''<CMD>lua require("visual-whitespace").toggle()<CR>'';
      options = {
        desc = "White space character toggle";
      };
    }
  ];
}
