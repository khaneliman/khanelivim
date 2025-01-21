{ config, lib, ... }:
{
  plugins = {
    avante = {
      enable = true;

      settings = {
        mappings = {
          files = {
            add_current = "<leader>aC";
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>a";
        group = "AI";
        icon = "";
      }
    ];
  };
}
