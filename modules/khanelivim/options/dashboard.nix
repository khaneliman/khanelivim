{ lib, ... }:
{
  options.khanelivim.dashboard = {
    tool = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
          "mini-starter"
        ]
      );
      default = "snacks";
      description = "Dashboard tool to use";
    };
  };
}
