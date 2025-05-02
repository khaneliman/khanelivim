{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.img-clip.enable = lib.mkEnableOption "img-clip" // {
    default = true;
  };

  config =
    let
      luaConfig = # Lua
        ''
          require ("img-clip").setup({
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
            }
          })
        '';
    in
    lib.mkIf config.plugins.img-clip.enable {
      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.img-clip-nvim;
          optional = config.plugins.lz-n.enable;
        }
      ];

      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "img-clip.nvim";
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
