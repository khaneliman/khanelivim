{
  config,
  lib,
  self,
  system,
  ...
}:
{
  plugins = {
    avante = {
      enable = true;
      package = self.packages.${system}.avante;
      # package = pkgs.vimPlugins.avante-nvim;

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        mappings = {
          files = {
            add_current = "<leader>a.";
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>a";
        group = "Avante";
        icon = "";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.avante.enable [
    {
      mode = "n";
      key = "<leader>ac";
      action = "<CMD>AvanteClear<CR>";
      options.desc = "avante: clear";
    }
  ];
}
