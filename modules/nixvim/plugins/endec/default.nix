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
          -- Custom keymaps configured to avoid conflicts with mini.surround and flash
          -- Using 'ge' prefix instead of conflicting 'gy', 'gs', 'gl' mappings
          require('endec').setup({
            keymaps = {
              -- Base64
              decode_base64_inplace = "gei",
              vdecode_base64_inplace = "gei",
              decode_base64_popup = "geI",
              vdecode_base64_popup = "geI",
              encode_base64_inplace = "geB",
              vencode_base64_inplace = "geB",

              -- Base64 URL
              decode_base64url_inplace = "ges",
              vdecode_base64url_inplace = "ges",
              decode_base64url_popup = "geS",
              vdecode_base64url_popup = "geS",
              encode_base64url_inplace = "geb",
              vencode_base64url_inplace = "geb",

              -- URL
              decode_url_inplace = "gel",
              vdecode_url_inplace = "gel",
              decode_url_popup = "geL",
              vdecode_url_popup = "geL",
              encode_url_inplace = "geu",
              vencode_url_inplace = "geu",
            }
          })
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
