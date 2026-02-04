{ config, lib, ... }:
let
  cfg = config.plugins.gitignore;
in
{
  plugins = {
    gitignore = {
      enable = true;

      lazyLoad.settings = {
        keys = [ "<leader>gI" ];
        cmd = [ "Gitignore" ];
      };
    };
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>gI";
      action.__raw = ''
        function()
          require('gitignore').generate()
        end
      '';
      options = {
        desc = "Gitignore generate";
        silent = true;
      };
    }
  ];
}
