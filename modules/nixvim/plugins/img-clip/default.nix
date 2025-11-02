{ config, lib, ... }:
{
  config = {
    plugins = {
      img-clip = {
        enable = lib.elem "img-clip" config.khanelivim.utilities.clipboard;
        lazyLoad.settings = {
          event = [ "DeferredUIEnter" ];
          keys = [
            {
              __unkeyed-1 = "<leader>p";
              __unkeyed-2 = "<cmd>PasteImage<cr>";
              desc = "Paste image from system clipboard";
            }
          ];
        };

        settings = {
          default = {
            prompt_for_file_name = false;
            drag_and_drop = {
              # TODO: figure out 'content not an image' warning
              enabled = false;
              insert_mode = true;
            };
          };
        };
      };
    };
  };
}
