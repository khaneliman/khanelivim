{ lib, ... }:
{
  options.khanelivim.editor = {
    # keep-sorted start block=yes newline_separated=yes
    autopairs = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "mini-pairs" ]);
      default = "mini-pairs";
      description = "Auto-pairing plugin to use";
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
    # keep-sorted end
  };
}
