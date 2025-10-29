{
  config,
  lib,
  ...
}:
{
  plugins.telescope = lib.mkIf (config.khanelivim.picker.tool == "telescope") {
    extensions = {
      fzf-native = {
        enable = true;
      };
    };
  };
}
