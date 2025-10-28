{ lib, ... }:
{
  options.khanelivim.documentation = {
    viewers = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "devdocs"
          "helpview"
          "glow"
        ]
      );
      default = [
        "helpview"
        "glow"
        "devdocs"
      ];
      description = "Documentation viewing plugins (can coexist)";
    };
  };
}
