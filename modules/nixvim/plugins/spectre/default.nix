{ lib, config, ... }:
{
  plugins = {
    spectre = {
      enable = !config.plugins.grug-far.enable;
      lazyLoad = {
        settings = {
          cmd = "Spectre";
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.spectre.enable [
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
