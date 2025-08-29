{
  config,
  lib,
  self,
  system,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.lensline = {
    enable = lib.mkEnableOption "lensline" // {
      default = true;
    };

    package = lib.mkPackageOption self.packages.${system} "lensline" {
      default = "lensline";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        providers = [
          {
            name = "references";
            enabled = true;
            quiet_lsp = true;
          }
          {
            name = "last_author";
            enabled = true;
            cache_max_files = 100;
          }
          {
            name = "diagnostics";
            enabled = true;
            min_level = "HINT";
          }
          {
            name = "complexity";
            enabled = true;
            min_level = "M";
          }
        ];
        limits = {
          exclude_gitignored = true;
          max_lines = 2000;
          max_lenses = 100;
        };
        debounce_ms = 300;
      };
      description = "Configuration for lensline";
    };
  };

  config = lib.mkIf config.plugins.lensline.enable {
    extraPlugins = [
      config.plugins.lensline.package
    ];

    extraConfigLua = ''
      require('lensline').setup(${lib.generators.toLua { } config.plugins.lensline.settings})
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>ul";
        action = "<cmd>LenslineToggle<CR>";
        options = {
          desc = "Lensline toggle";
        };
      }
    ];
  };
}
