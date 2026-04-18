{
  config,
  lib,
  ...
}:
let
  cfg = config.khanelivim.integrations.accountBacked;
in
{
  options.khanelivim.integrations.accountBacked = {
    enable = lib.mkEnableOption "account-backed integrations" // {
      default = true;
      description = ''
        Master gate for integrations that require an account, login, token, or
        API key.

        When disabled, all account-backed categories are forced off regardless
        of their individual settings.
      '';
    };

    ai.enable = lib.mkEnableOption "account-backed AI integrations" // {
      default = true;
    };

    timeTracking.enable = lib.mkEnableOption "account-backed time tracking integrations" // {
      default = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (!cfg.enable || !cfg.ai.enable) {
      khanelivim.ai = {
        plugins = lib.mkForce [ ];
        chatEnable = lib.mkForce false;
      };
    })
    (lib.mkIf (!cfg.enable || !cfg.timeTracking.enable) {
      plugins.wakatime.enable = lib.mkForce false;
    })
  ];
}
