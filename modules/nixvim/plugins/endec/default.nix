{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.endec = {
    enable = lib.mkEnableOption "endec" // {
      default = true;
    };
  };

  config =
    let
      luaConfig = # Lua
        ''
          -- TODO: configure keymaps to avoid conflicts
          --IFRPRE86IGNvbmZpZ3VyZSBrZXltYXBzIHRvIGF2b2lkIGNvbmZsaWN0cw==
          -- Default Key Mappings
          --
          -- The mappings below work for both visual and normal modes (mapping should be followed by a motion in normal mode).
          -- Mapping 	Description
          -- gb 	Decode Base64 in a popup
          -- gyb 	Decode Base64 in-place
          -- gB 	Encode Base64 in-place
          -- gs 	Decode Base64URL in a popup
          -- gys 	Decode Base64URL in-place
          -- gS 	Encode Base64URL in-place
          -- gl 	Decode URL in a popup
          -- gyl 	Decode URL in-place
          -- gL 	Encode URL in-place
          require('endec').setup({})
        '';
    in
    lib.mkIf config.plugins.endec.enable {
      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.endec-nvim;
          optional = config.plugins.lz-n.enable;
        }
      ];

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "endec.nvim";
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
    };
}
