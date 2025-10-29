{ lib, ... }:
{
  options.khanelivim.completion = {
    engine = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "blink"
          "nvim-cmp"
        ]
      );
      default = "blink";
      description = "Completion engine to use";
    };
  };
}
