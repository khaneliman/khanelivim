{ config, lib, ... }:
{
  config = {
    plugins = {
      img-clip = {
        enable = lib.elem "img-clip" config.khanelivim.utilities.screenshots;
        lazyLoad.settings.event = [ "DeferredUIEnter" ];

        settings = {

          default = {
            embed_image_as_base64 = false;
            prompt_for_file_name = false;
            drag_and_drop = {
              insert_mode = true;
            };
          };
        };
      };
    };
  };
}
