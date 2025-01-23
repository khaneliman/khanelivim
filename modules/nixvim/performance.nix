{ config, lib, ... }:
let
  snacksPickerEnabled =
    config.plugins.snacks.enable
    && lib.hasAttr "profiler" config.plugins.snacks.settings
    && config.plugins.snacks.settings.profiler.enabled;

  lazyEnabled = config.plugins.lz-n.enable || config.plugins.lazy.enable;
in
{
  performance = {
    byteCompileLua = {
      enable = !lazyEnabled;
      nvimRuntime = !lazyEnabled;
      configs = !snacksPickerEnabled;
      plugins = !snacksPickerEnabled;
    };
  };
}
