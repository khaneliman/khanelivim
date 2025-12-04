{ lib, ... }:
{
  options.khanelivim.completion = {
    tool = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "blink" ]);
      default = "blink";
      description = "Completion tool to use";
    };

    wordProvider = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "dictionary"
          "words"
        ]
      );
      default = "words";
      description = "Word completion provider (dictionary for synonyms, words for offline word completion)";
    };
  };
}
