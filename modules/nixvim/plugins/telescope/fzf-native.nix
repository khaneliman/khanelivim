{
  config,
  lib,
  ...
}:
{
  plugins.telescope = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
    extensions = {
      fzf-native = {
        enable = true;
      };
    };
  };
}
