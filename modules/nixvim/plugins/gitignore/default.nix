{ config, lib, ... }:
let
  cfg = config.plugins.gitignore;
in
{
  plugins = {
    gitignore = {
      # gitignore.nvim documentation
      # See: https://github.com/wintermute-cell/gitignore.nvim
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
