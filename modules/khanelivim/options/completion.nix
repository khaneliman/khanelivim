{ lib, ... }:
{
  options.khanelivim.completion = {
    engine = lib.mkOption {
      type = lib.types.enum [
        "blink"
        "nvim-cmp"
        "none"
      ];
      default = "blink";
      description = "Completion engine to use";
    };
  };
}
