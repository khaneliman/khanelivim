{ lib, config, ... }:
{
  plugins = {
    spectre = {
      enable = true;
      lazyLoad = {
        settings = {
          keys = [
            {
              __unkeyed-1 = "<leader>rs";
              __unkeyed-2 = "<cmd>Spectre<CR>";
              desc = "Spectre toggle";
            }
          ];
        };
      };
    };
  };

  keymaps = lib.mkIf (config.plugins.spectre.enable && !config.plugins.lz-n.enable) [
    {
      mode = "n";
      key = "<leader>rs";
      action = "<cmd>Spectre<CR>";
      options = {
        desc = "Spectre toggle";
      };
    }
  ];
}
