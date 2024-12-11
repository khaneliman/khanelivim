{
  plugins = {
    overseer = {
      enable = true;

      lazyLoad.settings.cmd = [
        "OverseerOpen"
        "OverseerClose"
        "OverseerToggle"
        "OverseerSaveBundle"
        "OverseerLoadBundle"
        "OverseerDeleteBundle"
        "OverseerRunCmd"
        "OverseerRun"
        "OverseerInfo"
        "OverseerBuild"
        "OverseerQuickAction"
        "OverseerTaskAction"
        "OverseerClearCache"
      ];
    };
  };
}
