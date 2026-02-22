{ config, lib, ... }:
{
  config = {
    plugins = {
      img-clip = {
        # img-clip.nvim documentation
        # See: https://github.com/HakonHarnes/img-clip.nvim
        enable = lib.elem "img-clip" config.khanelivim.utilities.clipboard;
        lazyLoad.settings = {
          event = [ "DeferredUIEnter" ];
          keys = [
            {
              __unkeyed-1 = "<leader>P";
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

      which-key.settings.spec =
        lib.optionals (lib.elem "img-clip" config.khanelivim.utilities.clipboard)
          [
            {
              __unkeyed-1 = "<leader>P";
              icon = "󰋩";
            }
          ];
    };
  };
}
