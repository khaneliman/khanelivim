{ lib, ... }:
{
  options.khanelivim.dashboard = {
    plugin = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
          "mini-starter"
        ]
      );
      default = "mini-starter";
      description = "Dashboard plugin to use";
    };
  };
}
