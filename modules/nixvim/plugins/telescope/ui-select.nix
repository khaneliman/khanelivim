{
  config,
  lib,
  ...
}:
{
  plugins.telescope = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
    extensions = {
      ui-select = {
        enable = true;
        settings = {
          __unkeyed-1.__raw = ''require("telescope.themes").get_dropdown{}'';
        };
      };
    };
  };
}
