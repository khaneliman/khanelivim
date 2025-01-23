{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    avante = {
      enable = true;
      package = pkgs.vimPlugins.avante-nvim.overrideAttrs {
        patches = [
          # Patch blink support
          (pkgs.fetchpatch {
            url = "https://github.com/doodleEsc/avante.nvim/commit/a5438d0f16208b7ae9e97ae354bed5ec16b4f9ed.patch";
            hash = "sha256-KyfO9dE27yMXOQhpit7jmzkvnfM7b5kr2Acoh011lXA=";
          })
        ];
      };

      lazyLoad.settings.event = [ "BufEnter" ];

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
