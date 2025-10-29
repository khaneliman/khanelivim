{ lib, ... }:
{
  options.khanelivim.picker = {
    engine = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
          "telescope"
          "fzf"
        ]
      );
      default = "snacks";
      description = "Fuzzy finder/picker engine to use";
    };
  };
}
