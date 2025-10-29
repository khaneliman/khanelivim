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

    statusColumn = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "statuscol"
          "snacks"
        ]
      );
      default = "snacks";
      description = "Status column plugin to use (mutually exclusive)";
    };

    notifications = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "mini-notify"
          "noice"
          "snacks"
        ]
      );
      default = [ "noice" ];
      description = "Notification systems to use (can complement each other)";
    };
  };
}
