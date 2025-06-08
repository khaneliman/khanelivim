{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.PLUGIN_NAME = {
    enable = lib.mkEnableOption "PLUGIN_NAME" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "PLUGIN_NAME" {
      default = "PLUGIN_NAME-nvim";
    };

    # Add plugin-specific options here
    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for PLUGIN_NAME";
    };
  };

  config = lib.mkIf config.plugins.PLUGIN_NAME.enable {
    extraPlugins = [
      config.plugins.PLUGIN_NAME.package
    ];

    # Plugin configuration
    extraConfigLua = ''
      require('PLUGIN_NAME').setup(${lib.generators.toLua { } config.plugins.PLUGIN_NAME.settings})
    '';

    # Optional: Add keymaps for the plugin
    keymaps = [
      {
        mode = "n";
        key = "<leader>XX";
        action = "<cmd>PluginCommand<CR>";
        options = {
          desc = "Plugin description";
        };
      }
    ];
  };
}
