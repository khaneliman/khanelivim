{ config, lib, ... }:
{
  plugins = {
    overseer = {
      enable = config.khanelivim.tasks.tool == "overseer";

      lazyLoad.settings.cmd = [
        "OverseerOpen"
        "OverseerClose"
        "OverseerToggle"
        "OverseerSaveBundle"
        "OverseerLoadBundle"
        "OverseerDeleteBundle"
        "OverseerShell"
        "OverseerRun"
        "OverseerTaskAction"
        "OverseerClearCache"
      ];
    };
  };

  keymaps = lib.mkIf (config.khanelivim.tasks.tool == "overseer") [
    {
      mode = "n";
      key = "<leader>RR";
      action = "<cmd>OverseerRun<CR>";
      options = {
        desc = "Run Task";
      };
    }
    {
      mode = "n";
      key = "<leader>Ro";
      action = "<cmd>OverseerOpen<CR>";
      options = {
        desc = "Open Output";
      };
    }
    {
      mode = "n";
      key = "<leader>Rt";
      action = "<cmd>OverseerToggle<CR>";
      options = {
        desc = "Toggle Output";
      };
    }
    {
      mode = "n";
      key = "<leader>Rs";
      action = "<cmd>OverseerShell<CR>";
      options = {
        desc = "Run Shell Command";
      };
    }
    {
      mode = "n";
      key = "<leader>RA";
      action = "<cmd>OverseerTaskAction<CR>";
      options = {
        desc = "Task Action";
      };
    }
  ];

}
