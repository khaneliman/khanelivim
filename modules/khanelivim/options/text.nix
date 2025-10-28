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
  };
}
