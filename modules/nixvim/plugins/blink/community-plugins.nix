{ config, ... }:
let
  mkBlinkPlugin =
    {
      enable ? true,
      ...
    }@args:
    {
      inherit enable;
      lazyLoad.settings.event = [
        "InsertEnter"
        "CmdlineEnter"
      ];
    }
    // (builtins.removeAttrs args [ "enable" ]);
in
{
  plugins = {
    # keep-sorted start block=yes
    blink-cmp-dictionary = mkBlinkPlugin {
      enable = config.khanelivim.completion.wordProvider == "dictionary";
    };
    blink-cmp-git = mkBlinkPlugin { };
    blink-cmp-spell = mkBlinkPlugin { };
    blink-cmp-words = mkBlinkPlugin {
      enable = config.khanelivim.completion.wordProvider == "words";
    };
    blink-copilot = mkBlinkPlugin {
      enable =
        builtins.elem "copilot" config.khanelivim.ai.plugins
        && config.khanelivim.completion.tool == "blink";
    };
    blink-emoji = mkBlinkPlugin { };
    blink-ripgrep = mkBlinkPlugin { };
    # keep-sorted end
  };
}
