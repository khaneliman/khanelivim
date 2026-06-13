{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.treesitter-modules;
  luaConfig = ''
    require('treesitter-modules').setup(${lib.generators.toLua { } cfg.settings})
  '';
in
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

  config = lib.mkIf cfg.enable {
    extraPlugins = [
      {
        plugin = cfg.package;
        optional = config.plugins.lz-n.enable;
      }
    ];

    extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

    plugins.lz-n.plugins = lib.mkIf config.plugins.lz-n.enable [
      {
        __unkeyed-1 = "treesitter-modules.nvim";
        event = "FileType";
        after.__raw = ''
          function()
            ${luaConfig}
          end
        '';
      }
    ];
  };
}
