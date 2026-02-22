{ config, lib, ... }:
{
  plugins = {
    neogen = {
      # neogen documentation
      # See: https://github.com/danymat/neogen
      enable = true;
      lazyLoad.settings.cmd = "Neogen";
    };
  };

  keymaps = lib.mkIf config.plugins.neogen.enable [
    {
      mode = "n";
      key = "<leader>lA";
      action = "<cmd>Neogen<cr>";
      options = {
        desc = "Generate Annotation";
      };
    }
  ];
}
