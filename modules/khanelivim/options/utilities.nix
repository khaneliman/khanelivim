{ lib, ... }:
{
  options.khanelivim.utilities = {
    # keep-sorted start block=yes newline_separated=yes
    screenshots = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "codesnap"
          "img-clip"
        ]
      );
      default = [ "codesnap" ];
      description = "Screenshot/image plugins (different use cases)";
    };

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
    #keep-sorted end
  };
}
