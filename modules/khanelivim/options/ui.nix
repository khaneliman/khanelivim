{ lib, ... }:
{
  options.khanelivim.ui = {
    # keep-sorted start block=yes newline_separated=yes
    animations = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
          "mini-animate"
        ]
      );
      default = "snacks";
      description = "Animation plugin for UI transitions (mutually exclusive)";
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

    bufferline = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "bufferline" ]);
      default = "bufferline";
      description = "Bufferline/tabline plugin to use";
    };

    commandline = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "noice"
        ]
      );
      default = "noice";
      description = "Command line UI enhancement to use";
    };

    indentGuides = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "blink-indent"
          "mini-indentscope"
          "snacks"
        ]
      );
      default = "blink-indent";
      description = "Indent guides plugin to use (mutually exclusive)";
    };

    keybindingHelp = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "which-key"
          "mini-clue"
        ]
      );
      default = "which-key";
      description = "Keybinding help/hints plugin to use (mutually exclusive)";
    };

    notifications = lib.mkOption {
      type = lib.types.enum [
        "mini-notify"
        "noice"
        "snacks"
      ];
      default = "noice";
      description = "Notification system to use (mutually exclusive)";
    };

    referenceHighlighting = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks-words"
          "mini-cursorword"
        ]
      );
      default = "snacks-words";
      description = "LSP reference/word highlighting plugin to use (mutually exclusive)";
    };

    renamePopup = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
          "noice"
        ]
      );
      default = "snacks";
      description = "Rename popup UI provider to use";
    };

    statusColumn = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
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
          "snacks"
        ]
      );
      default = [ "snacks" ];
      description = "Terminal emulator plugins to use (can have multiple)";
    };

    theme = lib.mkOption {
      type = lib.types.enum [
        "catppuccin"
        "nord"
      ];
      default = "catppuccin";
      description = "Colorscheme/theme to use";
    };

    zenMode = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "snacks"
        ]
      );
      default = "snacks";
      description = "Zen/centered editing mode plugin to use (mutually exclusive)";
    };
    #keep-sorted end
  };
}
