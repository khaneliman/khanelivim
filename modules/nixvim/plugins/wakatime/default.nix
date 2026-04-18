{ config, ... }:
{
  # vim-wakatime documentation
  # See: https://github.com/wakatime/vim-wakatime
  plugins.wakatime.enable =
    config.khanelivim.integrations.accountBacked.enable
    && config.khanelivim.integrations.accountBacked.timeTracking.enable;
}
