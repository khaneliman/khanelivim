{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.treesitter-modules = {
    enable = lib.mkEnableOption "treesitter-modules" // {
      default = config.plugins.treesitter.enable;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "treesitter-modules" {
      default = "treesitter-modules-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<A-o>";
            node_incremental = "<A-o>";
            scope_incremental = "<A-O>";
            node_decremental = "<A-i>";
          };
        };
      };
      description = ''
        Configuration for treesitter-modules.

        See <https://github.com/nvim-treesitter/nvim-treesitter>
      '';
    };
  };

  config = lib.mkIf config.plugins.treesitter-modules.enable {
    extraPlugins = [
      config.plugins.treesitter-modules.package
    ];

    extraConfigLua = ''
      require('treesitter-modules').setup(${
        lib.generators.toLua { } config.plugins.treesitter-modules.settings
      })
    '';
  };
}
