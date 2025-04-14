{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.plugins.visual-whitespace-nvim.enable = lib.mkEnableOption "visual-whitespace-nvim" // {
    default = true;
  };

  config = lib.mkIf config.plugins.visual-whitespace-nvim.enable {
    extraPlugins = [
      {
        plugin = pkgs.vimPlugins.visual-whitespace-nvim;
        optional = true;
      }
    ];

    plugins = {
      lz-n = {
        enable = true;
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
            after = # Lua
              ''
                function()
                  require("visual-whitespace").setup({
                    enabled = false
                  })
                end
              '';
          }
        ];
      };
    };
  };
}
