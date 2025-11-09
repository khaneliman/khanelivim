{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.plugins.blink-indent = {
    enable = lib.mkEnableOption "blink-indent" // {
      default = config.khanelivim.ui.indentGuides == "blink-indent";
    };

    package = lib.mkPackageOption pkgs.vimPlugins "blink-indent" {
      default = "blink-indent";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for blink-indent";
    };
  };

  config =
    let
      luaConfig = # Lua
        ''
          require('blink.indent').setup(${lib.generators.toLua { } config.plugins.blink-indent.settings})
        '';
    in
    lib.mkIf config.plugins.blink-indent.enable {
      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      extraPlugins = [
        {
          plugin = config.plugins.blink-indent.package;
          optional = config.plugins.lz-n.enable;
        }
      ];

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "blink.indent";
              event = [ "DeferredUIEnter" ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>ui";
          action.__raw = ''
            function()
              local indent = require('blink.indent')
              indent.enable(not indent.is_enabled())
              vim.notify(string.format("Indent Guides %s", bool2str(indent.is_enabled())), "info")
            end
          '';
          options.desc = "Indent Guides toggle";
        }
      ];
    };
}
