{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = [
    pkgs.vimPlugins.vs-tasks-nvim
  ];

  plugins.telescope = {
    luaConfig.post = ''
      require("vstask").setup()
      require("telescope").load_extension("vstask")
    '';
  };

  keymaps = lib.mkIf (config.plugins.telescope.enable && (!config.plugins.overseer.enable)) [
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
