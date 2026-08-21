{ config, lib, ... }:
let
  gate = config.khanelivim.integrations.accountBacked;

  # These plugins reach a local endpoint, so they need no account, token, or
  # API key. The account-backed gate must keep them.
  localPlugins = [ "minuet" ];
in
{
  options.khanelivim.ai = {
    plugins = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "avante"
          "claudecode"
          "codecompanion"
          "codex"
          "copilot"
          "copilot-lsp"
          "gemini"
          "minuet"
          "opencode"
          "sidekick"
          "windsurf"
        ]
      );
      default = [
        "claudecode"
        "copilot"
        "copilot-lsp"
        "codex"
        "gemini"
        "opencode"
        "sidekick"
      ];
      # The account-backed gate filters the merged value here. It cannot force
      # this option instead, because reading the list to filter it would create
      # an evaluation cycle.
      apply =
        plugins: if gate.enable && gate.ai.enable then plugins else lib.intersectLists plugins localPlugins;

      description = ''
        List of AI plugins to enable.
        Multiple plugins can be enabled simultaneously.
        Set to [] to disable all AI features.

        Disabling khanelivim.integrations.accountBacked.ai keeps only the
        plugins that serve completions from a local endpoint.

        Available plugins:
        - avante: Claude AI interface with inline editing
        - claudecode: Claude Code integration
        - codecompanion: Gemini-based AI assistant
        - codex: OpenAI Codex integration
        - copilot: GitHub Copilot (includes chat)
        - copilot-lsp: GitHub Copilot LSP integration
        - minuet: Local completion at the cursor, served by ollama
        - opencode: OpenCode AI assistant with snacks integration
        - sidekick: Multi-provider AI suggestion system (Claude, Copilot, Gemini, Opencode)
        - windsurf: Codeium Windsurf integration
      '';
    };

    chatEnable = lib.mkEnableOption "AI chat functionality" // {
      default = true;
    };
  };
}
