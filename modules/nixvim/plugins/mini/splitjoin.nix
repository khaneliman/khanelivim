{ config, lib, ... }:
{
  plugins.mini-splitjoin = lib.mkIf (config.khanelivim.text.splitJoin == "mini-splitjoin") {
    enable = true;
    settings = {
      mappings = {
        toggle = "gS"; # Toggle split/join
      };
    };
  };
}
