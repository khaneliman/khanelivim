{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.visual-whitespace-nvim.enable = lib.mkEnableOption "visual-whitespace-nvim" // {
    default = true;
  };

  config =
    let
      luaConfig = # Lua
        ''
          require("visual-whitespace").setup({
            enabled = false
          })
        '';
    in
    lib.mkIf config.plugins.visual-whitespace-nvim.enable {
      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.visual-whitespace-nvim;
          optional = config.plugins.lz-n.enable;
        }
      ];

      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "visual-whitespace.nvim";
              keys = [
                {
                  __unkeyed-1 = "<leader>uW";
                  __unkeyed-3 = "<CMD>lua require('visual-whitespace').toggle()<CR>";
                  mode = [
                    "v"
                    "n"
                  ];
                  desc = "White space character toggle";
                }
              ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };
      };
    };
}
