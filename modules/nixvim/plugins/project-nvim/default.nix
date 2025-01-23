{ config, lib, ... }:
{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = config.plugins.telescope.enable;

    # TODO: fix lazy loading
    # lazyLoad.settings.cmd = "Telescope projects";
    lazyLoad.settings.event = "DeferredUIEnter";
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.telescope.enable
        && config.plugins.project-nvim.enable
        && (
          !config.plugins.snacks.enable
          || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
        )
      )
      [
        {
          mode = "n";
          key = "<leader>fp";
          action = "<cmd>Telescope projects<CR>";
          options = {
            desc = "Find projects";
          };
        }
      ];
}
