{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf (config.khanelivim.tasks.tool == "vs-tasks") [
    pkgs.vimPlugins.vs-tasks-nvim
  ];

  # Setup vs-tasks
  plugins.lz-n.plugins = lib.mkIf (config.khanelivim.tasks.tool == "vs-tasks") [
    {
      __unkeyed-1 = "vs-tasks-nvim";
      lazy = false;
      after.__raw = ''
        function()
          require("vstask").setup({
            picker = "${config.khanelivim.picker.tool}"
          })
        end
      '';
    }
  ];

  keymaps = lib.mkIf (config.khanelivim.tasks.tool == "vs-tasks") [
    {
      mode = "n";
      key = "<leader>RT";
      action = "<cmd>VstaskViewTasks<CR>";
      options = {
        desc = "Find tasks";
      };
    }
  ];
}
