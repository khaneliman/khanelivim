{ lib, ... }:
{
  options.khanelivim.completion = {
    tool = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "blink" ]);
      default = "blink";
      description = "Completion tool to use";
    };
  };
}
