{
  config,
  lib,
  pkgs,
  ...
}:
{
  # NOTE: vs-tasks-nvim has telescope-nvim as a hard dependency in nixpkgs
  # This means telescope will be installed even if not using telescope picker
  extraPlugins =
    lib.mkIf
      (config.khanelivim.tasks.runner == "vs-tasks" && config.khanelivim.picker.engine == "telescope")
      [
        pkgs.vimPlugins.vs-tasks-nvim
      ];

  plugins.telescope =
    lib.mkIf
      (config.khanelivim.picker.engine == "telescope" && config.khanelivim.tasks.runner == "vs-tasks")
      {
        luaConfig.post = ''
          require("vstask").setup()
          require("telescope").load_extension("vstask")
        '';
      };

  keymaps =
    lib.mkIf
      (config.khanelivim.picker.engine == "telescope" && config.khanelivim.tasks.runner == "vs-tasks")
      [
        {
          mode = "n";
          key = "<leader>RT";
          action = "<cmd>Telescope vstask tasks<CR>";
          options = {
            desc = "Find tasks";
          };
        }
      ];
}
