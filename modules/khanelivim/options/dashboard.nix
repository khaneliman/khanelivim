{ lib, ... }:
{
  options.khanelivim.dashboard = {
    plugin = lib.mkOption {
      type = lib.types.enum [
        "snacks"
        "mini-starter"
        "none"
      ];
      default = "mini-starter";
      description = "Dashboard plugin to use";
    };
  };
}
