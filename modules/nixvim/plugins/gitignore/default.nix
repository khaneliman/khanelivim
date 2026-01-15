{ config, lib, ... }:
let
  cfg = config.plugins.gitignore;
in
{
  plugins = {
    gitignore = {
      enable = true;

      # TODO: migrate to mkNeovimPlugin
      # lazyLoad.settings.keys = [ "<leader>gI" ];
      # lazyLoad.settings.cmd = [ "Gitignore" ];
    };
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>gI";
      action.__raw = "require('gitignore').generate";
      options = {
        desc = "Gitignore generate";
        silent = true;
      };
    }
  ];
}
