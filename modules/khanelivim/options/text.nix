{ lib, ... }:
{
  options.khanelivim.text = {
    # keep-sorted start block=yes newline_separated=yes
    comments = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "comment-box"
          "ts-comments"
          "mini-comment"
        ]
      );
      default = [
        "comment-box"
        "ts-comments"
        "mini-comment"
      ];
      description = "Text commenting plugins to use (can complement each other)";
    };

    markdownRendering = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "markview"
          "markdown-preview"
        ]
      );
      default = [
        "markview"
        "markdown-preview"
      ];
      description = "Markdown rendering and preview plugins (can coexist)";
    };

    operators = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [ "mini-operators" ]);
      default = [ "mini-operators" ];
      description = "Text edit operators (exchange, replace, multiply, etc.)";
    };

    patterns = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "todo-comments"
          "mini-hipatterns"
        ]
      );
      default = [
        "todo-comments"
        "mini-hipatterns"
      ];
      description = "Text pattern highlighting plugins (can work together)";
    };

    splitJoin = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "mini-splitjoin" ]);
      default = "mini-splitjoin";
      description = "Plugin for splitting and joining arguments/arrays/objects";
    };

    whitespace = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "whitespace-custom"
          "whitespace-nvim"
          "mini-trailspace"
        ]
      );
      default = "whitespace-custom";
      description = "Trailing whitespace highlighting and removal plugin (mutually exclusive)";
    };
    # keep-sorted end
  };
}
