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

    statusline = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "lualine" ]);
      default = "lualine";
      description = "Statusline plugin to use";
    };

    bufferline = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "bufferline" ]);
      default = "bufferline";
      description = "Bufferline/tabline plugin to use";
    };
  };
}
