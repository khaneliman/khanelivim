{ config, lib, ... }:
{
  plugins.showkeys = {
    enable = true;

    lazyLoad.settings = {
      event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };

    settings = {
      position = "top-right";
      timeout = 2;
      maxkeys = 5;
    };
  };

  keymaps = lib.optionals config.plugins.showkeys.enable [
    {
      mode = "n";
      key = "<leader>usk";
      action = "<cmd>ShowkeysToggle<CR>";
      options = {
        desc = "Toggle showkeys";
      };
    }
  ];
}
