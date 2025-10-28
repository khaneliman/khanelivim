{ lib, ... }:
{
  options.khanelivim.loading = {
    strategy = lib.mkOption {
      type = lib.types.enum [
        "lazy"
        "eager"
      ];
      default = "lazy";
      description = "Plugin loading strategy";
    };
  };
}
