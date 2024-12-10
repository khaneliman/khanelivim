{ lib, config, ... }:
{
  plugins = {
    spectre = {
      enable = true;
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
