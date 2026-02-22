{
  config,
  lib,
  self,
  system,
  ...
}:
let
  cfg = config.plugins.tuck;
  queryExtraFiles = lib.mapAttrs' (
    name: _:
    lib.nameValuePair "after/queries/tuck/${name}" {
      source = ./queries + "/${name}";
    }
  ) (lib.filterAttrs (_: type: type == "regular") (builtins.readDir ./queries));

  luaConfig = ''
    require('tuck').setup(${lib.generators.toLua { } cfg.settings})
  '';
in
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.tuck = {
    enable = lib.mkEnableOption "tuck" // {
      # FIXME: bug collapses all folds randomly
      # default = true;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${system}.tuck;
      defaultText = lib.literalExpression "self.packages.\${system}.tuck";
      description = "The tuck.nvim package to use.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration passed to `require('tuck').setup(...)`.";
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (!config.plugins.treesitter.enable) ''
      plugins.tuck requires treesitter to be enabled (plugins.treesitter.enable = true).
    '';

    # Auto-enable fzf-lua integration when fzf-lua is enabled, unless overridden.
    plugins.tuck.settings = {
      auto_unfold = false;
      integrations.fzf_lua = config.plugins.fzf-lua.enable;
    };

    extraFiles = lib.mkIf config.plugins.treesitter.enable queryExtraFiles;

    extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

    extraPlugins = [
      {
        plugin = cfg.package;
        optional = config.plugins.lz-n.enable;
      }
    ];

    plugins.lz-n.plugins = lib.mkIf config.plugins.lz-n.enable [
      {
        __unkeyed-1 = "tuck.nvim";
        event = [
          "BufReadPost"
          "BufNewFile"
        ];
        cmd = [ "Tuck" ];
        after.__raw = ''
          function()
            ${luaConfig}
          end
        '';
      }
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>uez";
        action = "<cmd>Tuck toggle<CR>";
        options = {
          desc = "Toggle tuck folds";
        };
      }
      {
        mode = "n";
        key = "<leader>ueZ";
        action = "<cmd>Tuck fold<CR>";
        options = {
          desc = "Re-apply tuck folds";
        };
      }
      {
        mode = "n";
        key = "<leader>ueD";
        action = "<cmd>Tuck debug<CR>";
        options = {
          desc = "Tuck debug";
        };
      }
    ];
  };
}
