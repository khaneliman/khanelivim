{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.plugins.gitignore;
in
{

  plugins = {
    gitignore = {
      enable = true;
    };
  };

  keymaps = mkIf cfg.enable [
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
