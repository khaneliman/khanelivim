{ config, lib, ... }:
{
  plugins = {
    snacks = {
      settings = {
        notifier.enabled = lib.elem "snacks" config.khanelivim.ui.notifications;
      };
    };
  };

  keymaps = lib.mkIf (lib.elem "snacks" config.khanelivim.ui.notifications) [
    {
      mode = "n";
      key = "<leader>un";
      action = "<cmd>lua Snacks.notifier.hide()<CR>";
      options = {
        desc = "Dismiss All Notifications";
      };
    }
    {
      mode = "n";
      key = "<leader>uN";
      action = "<cmd>lua Snacks.notifier.show_history()<CR>";
      options = {
        desc = "Show Notification History";
      };
    }
  ];
}
