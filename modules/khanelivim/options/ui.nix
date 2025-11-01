{ lib, ... }:
{
  options.khanelivim.ui = {
    # keep-sorted start block=yes newline_separated=yes
    bufferDelete = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "mini-bufremove"
          "snacks"
        ]
      );
      default = "snacks";
      description = "Buffer deletion strategy (mutually exclusive)";
    };

    bufferline = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "bufferline" ]);
      default = "bufferline";
      description = "Bufferline/tabline plugin to use";
    };

    commandline = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "noice"
          "wilder"
        ]
      );
      default = "noice";
      description = "Command line UI enhancement to use";
    };

    indentGuides = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "indent-blankline"
          "mini-indentscope"
          "snacks"
        ]
      );
      default = "snacks";
      description = "Indent guides plugin to use (mutually exclusive)";
    };

    notifications = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "mini-notify"
          "noice"
          "snacks"
        ]
      );
      default = [
        "noice"
        "snacks"
      ];
      description = "Notification systems to use (can complement each other)";
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

    statusline = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "lualine" ]);
      default = "lualine";
      description = "Statusline plugin to use";
    };

    terminal = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "toggleterm"
          "snacks"
        ]
      );
      default = [ "toggleterm" ];
      description = "Terminal emulator plugins to use (can have multiple)";
    };
    #keep-sorted end
  };
}
