{ lib, ... }:
{
  options.khanelivim.utilities = {
    # keep-sorted start block=yes newline_separated=yes
    clipboard = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "img-clip"
          "yanky"
        ]
      );
      default = [
        "yanky"
        "img-clip"
      ];
      description = "Clipboard enhancement plugins (complementary)";
    };

    screenshots = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "codesnap"
        ]
      );
      default = [ "codesnap" ];
      description = "Code screenshot plugins for sharing";
    };

    sessions = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "persistence"
          "project-nvim"
          "mini-sessions"
        ]
      );
      default = [ "persistence" ];
      description = "Session management plugins (can complement each other)";
    };
    #keep-sorted end
  };
}
