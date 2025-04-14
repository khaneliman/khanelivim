{
  pkgs,
  ...
}:
{
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.img-clip-nvim;
      optional = true;
    }
  ];

  plugins = {
    lz-n = {
      enable = true;
      plugins = [
        {
          __unkeyed-1 = "img-clip.nvim";
          event = [ "DeferredUIEnter" ];
          after = # Lua
            ''
              function()
                require ("img-clip").setup({
                  default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                      insert_mode = true,
                    },
                  }
                })
              end
            '';
        }
      ];
    };
  };
}
