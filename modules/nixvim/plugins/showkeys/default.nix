{ config, lib, ... }:
{
  plugins.showkeys = {
    enable = true;

    lazyLoad.settings = {
      event = [
        "DeferredUIEnter"
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
      key = "<leader>uk";
      action = "<cmd>ShowkeysToggle<CR>";
      options = {
        desc = "Toggle showkeys";
      };
    }
  ];
}
