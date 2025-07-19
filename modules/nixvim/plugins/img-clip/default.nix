{
  config = {
    plugins = {
      img-clip = {
        enable = true;
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
