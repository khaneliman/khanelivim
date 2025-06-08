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

  config =
    let
      luaConfig = # Lua
        ''
          require('PLUGIN_NAME').setup(${lib.generators.toLua { } config.plugins.PLUGIN_NAME.settings})

          -- Additional Lua configuration here
        '';
    in
    lib.mkIf config.plugins.PLUGIN_NAME.enable {
      # Conditional Lua config - only load if lz-n is disabled
      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      extraPlugins = [
        {
          plugin = config.plugins.PLUGIN_NAME.package;
          optional = config.plugins.lz-n.enable;
        }
      ];

      # Optional: Extra packages needed by the plugin
      # extraPackages = with pkgs; [
      #   # package-name
      # ];

      # lz-n lazy loading configuration
      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "PLUGIN_NAME.nvim";
              event = [ "DeferredUIEnter" ];
              # Optional: Other lazy loading triggers
              # cmd = [ "PluginCommand" ];
              # ft = [ "filetype" ];
              # keys = [
              #   { __unkeyed-1 = "<leader>XX"; desc = "Plugin action"; }
              # ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };
      };

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
