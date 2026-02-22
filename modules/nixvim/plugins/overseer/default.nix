{ config, lib, ... }:
{
  plugins = {
    overseer = {
      # overseer.nvim documentation
      # See: https://github.com/stevearc/overseer.nvim
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
    {
      mode = "n";
      key = "<leader>Rl";
      action.__raw = ''
        function()
          local overseer = require("overseer")
          local task_list = require("overseer.task_list")
          local tasks = overseer.list_tasks({
            status = {
              overseer.STATUS.SUCCESS,
              overseer.STATUS.FAILURE,
              overseer.STATUS.CANCELED,
            },
            sort = task_list.sort_finished_recently,
          })

          if vim.tbl_isempty(tasks) then
            vim.notify("No recent task found", vim.log.levels.WARN)
            return
          end

          overseer.run_action(tasks[1], "restart")
        end
      '';
      options = {
        desc = "Restart Last Task";
      };
    }
  ];

}
