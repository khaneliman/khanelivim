{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.patterns.enable = lib.mkEnableOption "patterns" // {
    default = true;
  };

  config = lib.mkIf config.plugins.patterns.enable {
    extraPlugins = [
      pkgs.vimPlugins.patterns-nvim
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>ph";
        action = "<cmd>Patterns hover<CR>";
        options = {
          desc = "Patterns hover";
        };
      }
      {
        mode = "n";
        key = "<leader>pe";
        action = "<cmd>Patterns explain<CR>";
        options = {
          desc = "Patterns explain";
        };
      }
    ];
  };
}
