{ lib, config, ... }:
{
  plugins = {
    spectre = {
      enable = config.khanelivim.editor.searchPlugin == "spectre";
      lazyLoad = {
        settings = {
          cmd = "Spectre";
        };
      };
    };
  };

  keymaps = lib.mkIf (config.khanelivim.editor.searchPlugin == "spectre") [
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
