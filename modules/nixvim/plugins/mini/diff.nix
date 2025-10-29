{ lib, config, ... }:
{
  plugins = {
    mini = {
      enable = true;

      modules = lib.mkIf (config.khanelivim.git.diffViewer == "mini-diff") {
        diff = {
          view = {
            style = "sign";
          };
        };
      };
    };

    which-key.settings.spec =
      lib.mkIf (config.plugins.mini.enable && lib.hasAttr "diff" config.plugins.mini.modules)
        [
          {
            __unkeyed = "<leader>gd";
            group = "Diff";
            icon = " ";
          }
        ];
  };

  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "diff" config.plugins.mini.modules) (
    [
      # Mini-diff specific keybind
      {
        mode = "n";
        key = "<leader>gdm";
        action.__raw = "MiniDiff.toggle_overlay";
        options = {
          desc = "Mini-diff Toggle Overlay";
          silent = true;
        };
      }
    ]
    ++ lib.optionals (config.khanelivim.git.diffViewer == "mini-diff") [
      # Primary diff shortcut when mini-diff is the chosen diff viewer
      {
        mode = "n";
        key = "<leader>gD";
        action.__raw = "MiniDiff.toggle_overlay";
        options = {
          desc = "Toggle Diff (Primary)";
          silent = true;
        };
      }
    ]
  );
}
