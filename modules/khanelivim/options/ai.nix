{ lib, ... }:
{
  options.khanelivim.ai = {
    provider = lib.mkOption {
      type = lib.types.enum [
        "copilot"
        "windsurf"
        "none"
      ];
      default = "copilot";
      description = "AI completion provider to use";
    };

    chatEnable = lib.mkEnableOption "AI chat functionality" // {
      default = true;
    };
  };
}
