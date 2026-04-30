{ lib, ... }:
{
  options.khanelivim.jj = {
    integrations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "jj"
          "jjsigns"
        ]
      );
      default = [
        "jj"
        "jjsigns"
      ];
      description = "Jujutsu integration plugins to enable.";
    };
  };
}
