{
  config,
  lib,
  ...
}:
{
  extraLuaPackages =
    ps:
    lib.optionals
      (
        # Plugins with known tiktoken_core usage
        config.plugins.copilot-lua.enable
        || config.plugins.avante.enable
        # Plugins with chat/session features that could benefit
        || config.plugins.codecompanion.enable
        || config.plugins.sidekick.enable
        || config.plugins.claude-code.enable
        || config.plugins.claudecode.enable
        || config.plugins.opencode.enable
      )
      [
        ps.tiktoken_core
      ];
}
