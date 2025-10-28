{ lib, ... }:
{
  options.khanelivim.picker = {
    engine = lib.mkOption {
      type = lib.types.enum [
        "snacks"
        "telescope"
        "fzf"
        "none"
      ];
      default = "snacks";
      description = "Fuzzy finder/picker engine to use";
    };
  };
}
