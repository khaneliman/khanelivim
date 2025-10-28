{ lib, ... }:
{
  options.khanelivim.editor = {
    debugUI = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "dap-ui"
          "dap-view"
        ]
      );
      default = "dap-ui";
      description = "Debug UI plugin (mutually exclusive)";
    };

    motionPlugin = lib.mkOption {
      type = lib.types.enum [
        "flash"
        "hop"
        "none"
      ];
      default = "flash";
      description = "Motion/jump plugin to use";
    };

    searchPlugin = lib.mkOption {
      type = lib.types.enum [
        "spectre"
        "grug-far"
        "none"
      ];
      default = "grug-far";
      description = "Search and replace plugin to use";
    };

    fileManager = lib.mkOption {
      type = lib.types.enum [
        "neo-tree"
        "yazi"
        "mini-files"
        "none"
      ];
      default = "yazi";
      description = "File manager plugin to use";
    };

    diffViewer = lib.mkOption {
      type = lib.types.enum [
        "diffview"
        "unified"
        "mini-diff"
        "none"
      ];
      default = "unified";
      description = "Diff viewer plugin to use";
    };

    snippetEngine = lib.mkOption {
      type = lib.types.enum [
        "luasnip"
        "mini-snippets"
        "none"
      ];
      default = "mini-snippets";
      description = "Snippet engine to use";
    };

    commandlineUI = lib.mkOption {
      type = lib.types.enum [
        "noice"
        "wilder"
        "none"
      ];
      default = "noice";
      description = "Command line UI enhancement to use";
    };

    httpClient = lib.mkOption {
      type = lib.types.enum [
        "rest"
        "kulala"
        "none"
      ];
      default = "kulala";
      description = "HTTP client plugin to use";
    };
  };
}
