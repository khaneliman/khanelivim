{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.unified = {
    enable = lib.mkEnableOption "unified" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "unified" {
      default = "unified-nvim";
    };

    # Add plugin-specific options here
    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for unified";
    };
  };

  config = lib.mkIf config.plugins.unified.enable {
    extraPlugins = [
      config.plugins.unified.package
    ];

    extraConfigLua = ''
      require('unified').setup(${lib.generators.toLua { } config.plugins.unified.settings})
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>Unified<CR>";
        options = {
          desc = "Open Unified Diff";
        };
      }
      {
        mode = "n";
        key = "<leader>gD";
        action = "<cmd>Unified HEAD~1<CR>";
        options = {
          desc = "Open Unified Diff (-1)";
        };
      }
      {
        mode = "n";
        key = "<leader>ugo";
        action = "<cmd>Unified<CR>";
        options = {
          desc = "Open Unified Diff";
        };
      }
      {
        mode = "n";
        key = "<leader>ugc";
        action = "<cmd>Unified reset<CR>";
        options = {
          desc = "Close Unified Diff";
        };
      }
    ];
  };
}
