{ config, lib, ... }:
{
  plugins = {
    snacks = {
      settings = {
        notifier = {
          enabled = config.khanelivim.ui.notifications == "snacks";

          style = "fancy"; # "compact" | "fancy" | "minimal"
        };
      };
    };
  };

  keymaps = lib.mkIf (config.khanelivim.ui.notifications == "snacks") [
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
