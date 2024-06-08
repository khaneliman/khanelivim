{ lib, config, ... }:
{

  plugins = {
    mini = {
      enable = true;

      modules = {
        diff = {
          view = {
            style = "sign";
          };
        };
      };
    };
  };

  keymaps = lib.mkIf (lib.hasAttr "diff" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>ugo";
      action.__raw = # lua
        "MiniDiff.toggle_overlay";
      options = {
        desc = "Git Overlay toggle";
        silent = true;
      };
    }
  ];
}
