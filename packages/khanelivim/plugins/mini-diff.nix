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

  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "diff" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>ugo";
      action.__raw = "MiniDiff.toggle_overlay";
      options = {
        desc = "Git Overlay toggle";
        silent = true;
      };
    }
  ];
}
