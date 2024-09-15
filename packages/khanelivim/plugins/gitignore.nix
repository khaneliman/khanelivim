{ config, lib, ... }:
let
  cfg = config.plugins.gitignore;
in
{
  plugins = {
    gitignore = {
      enable = true;
    };
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>gi";
      action.__raw = ''require('gitignore').generate'';
      options = {
        desc = "Gitignore generate";
        silent = true;
      };
    }
  ];
}
