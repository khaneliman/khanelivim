{ lib, ... }:
{
  options.khanelivim.ui = {
    indentGuides = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "indent-blankline"
          "mini-indentscope"
          "snacks"
        ]
      );
      default = "mini-indentscope";
      description = "Indent guides plugin to use (mutually exclusive)";
    };
  };
}
