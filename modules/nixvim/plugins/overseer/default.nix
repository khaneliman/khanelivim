{ config, lib, ... }:
{
  plugins = {
    overseer = {
      enable = config.khanelivim.tasks.runner == "overseer";

      lazyLoad.settings.cmd = [
        "OverseerOpen"
        "OverseerClose"
        "OverseerToggle"
        "OverseerSaveBundle"
        "OverseerLoadBundle"
        "OverseerDeleteBundle"
        "OverseerRunCmd"
        "OverseerRun"
        "OverseerInfo"
        "OverseerBuild"
        "OverseerQuickAction"
        "OverseerTaskAction"
        "OverseerClearCache"
      ];
    };
  };

  keymaps = lib.mkIf (config.khanelivim.tasks.runner == "overseer") [
    {
      mode = "n";
      key = "<leader>RT";
      action = "<cmd>OverseerRun<CR>";
      options = {
        desc = "Run Tasks";
      };
    }
  ];
}
