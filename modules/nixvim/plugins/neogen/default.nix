{ config, lib, ... }:
{
  plugins = {
    neogen = {
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
