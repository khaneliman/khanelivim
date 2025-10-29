{ lib, ... }:
{
  options.khanelivim.editor = {
    motion = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "flash"
          "hop"
        ]
      );
      default = "flash";
      description = "Motion/jump plugin to use";
    };

    search = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "spectre"
          "grug-far"
        ]
      );
      default = "grug-far";
      description = "Search and replace plugin to use";
    };

    fileManager = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "neo-tree"
          "yazi"
          "mini-files"
        ]
      );
      default = "yazi";
      description = "File manager plugin to use";
    };

    diffViewer = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "diffview"
          "unified"
          "mini-diff"
        ]
      );
      default = "unified";
      description = "Diff viewer plugin to use";
    };

    snippet = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "luasnip"
          "mini-snippets"
        ]
      );
      default = "mini-snippets";
      description = "Snippet engine to use";
    };

    commandlineUI = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "noice"
          "wilder"
        ]
      );
      default = "noice";
      description = "Command line UI enhancement to use";
    };

    httpClient = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "rest"
          "kulala"
        ]
      );
      default = "kulala";
      description = "HTTP client plugin to use";
    };
  };
}
