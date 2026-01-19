{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.tuis = {
    enable = lib.mkEnableOption "tuis" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "tuis" {
      default = "tuis-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for tuis";
    };
  };

  config = lib.mkIf config.plugins.tuis.enable {
    extraPlugins = [
      config.plugins.tuis.package
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>uT";
        action.__raw = ''
          function()
            require('tuis').choose()
          end
        '';
        options = {
          desc = "Choose TUI";
        };
      }
    ];
  };
}
