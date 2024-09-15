{ config, lib, ... }:
{
  plugins.yazi.enable = true;

  keymaps = lib.optionals config.plugins.yazi.enable [
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = ''
        function()
          require('yazi').yazi()
        end
      '';
      options = {
        desc = "Yazi toggle";
        silent = true;
      };
    }
  ];
}
