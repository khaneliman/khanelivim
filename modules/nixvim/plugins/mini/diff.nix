{ lib, config, ... }:
{
  plugins = {
    mini-diff = lib.mkIf (config.khanelivim.git.diffViewer == "mini-diff") {
      enable = true;
      settings = {
        view = {
          style = "sign";
        };
      };
    };

    which-key.settings.spec = lib.mkIf config.plugins.mini-diff.enable [
      {
        __unkeyed-1 = "<leader>gd";
        group = "Diff";
        icon = " ";
      }
      {
        __unkeyed-1 = "<leader>gdm";
        desc = "Toggle mini-diff overlay";
        icon = "󰦓";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.mini-diff.enable (
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
