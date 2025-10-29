{ lib, ... }:
{
  options.khanelivim.text = {
    commenting = lib.mkOption {
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
  };
}
