{ lib, ... }:
{
  options.khanelivim.utilities = {
    sessions = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "persistence"
          "project-nvim"
        ]
      );
      default = [ "persistence" ];
      description = "Session management plugins (can complement each other)";
    };
  };
}
