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

    localEndpoint = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:8090/v1";
      example = "http://gpu-host.lan:8090/v1";
      description = ''
        OpenAI-compatible base URL for locally served models.

        The default points at a proxy on this machine, so the flake works on
        its own. A host that runs the model elsewhere, or on another port, sets
        this once and every plugin that reads it follows. minuet names ollama
        directly, because it needs a fill-in-the-middle endpoint the proxy does
        not serve.
      '';
    };

    duetEnable = lib.mkEnableOption "minuet next edit prediction" // {
      description = ''
        Predict the next edit with a local model through minuet's duet module.

        Needs "minuet" in khanelivim.ai.plugins. Upstream calls duet
        experimental, so this stays off until a user opts in.

        Duet rewrites a region through a chat endpoint. Completion at the
        cursor uses a separate provider and a separate model.
      '';
    };
  };
}
