{ lib, config, ... }:
let
  cfg = config.khanelivim;
in
{
  options.khanelivim.profile = lib.mkOption {
    type = lib.types.enum [
      "minimal"
      "basic"
      "standard"
      "full"
    ];
    default = "full";
    description = ''
      Configuration profile preset for performance testing.

      - minimal: Just treesitter, LSP, completion - no UI enhancements
      - basic: Core editing + statusline + gitsigns + snacks picker
      - standard: Full features, deduplicated (one AI tool, one file manager, etc.)
      - full: All features enabled including duplicates (default)
    '';
  };

  config = lib.mkMerge [
    # Minimal: Just treesitter, LSP, completion
    (lib.mkIf (cfg.profile == "minimal") {
      khanelivim = {
        ai = {
          provider = lib.mkForce null;
          chatEnable = lib.mkForce false;
        };

        dashboard.tool = lib.mkForce null;

        debugging = {
          adapters = lib.mkForce [ ];
          ui = lib.mkForce null;
        };

        git = {
          integrations = lib.mkForce [ ];
          diffViewer = lib.mkForce null;
        };

        # Minimal editor - keep essentials
        editor = {
          fileManager = lib.mkForce null;
          httpClient = lib.mkForce null;
          motion = lib.mkForce null;
          search = lib.mkForce null;
        };

        # Disable picker (use native)
        picker.tool = lib.mkForce null;

        # Minimal text editing
        text = {
          comments = lib.mkForce [ ];
          markdownRendering = lib.mkForce [ ];
          operators = lib.mkForce [ ];
          patterns = lib.mkForce [ ];
          splitJoin = lib.mkForce null;
          whitespace = lib.mkForce null;
        };

        # Disable most UI
        ui = {
          animations = lib.mkForce null;
          bufferline = lib.mkForce null;
          commandline = lib.mkForce null;
          indentGuides = lib.mkForce null;
          keybindingHelp = lib.mkForce null;
          notifications = lib.mkForce "snacks"; # Keep minimal notifications
          referenceHighlighting = lib.mkForce null;
          statusColumn = lib.mkForce null;
          statusline = lib.mkForce null;
          terminal = lib.mkForce [ ];
        };

        # Disable utilities
        utilities = {
          clipboard = lib.mkForce [ ];
          screenshots = lib.mkForce [ ];
          sessions = lib.mkForce [ ];
        };
      };

      # Force disable plugins that nixvim modules enable by default
      plugins = {
        dap.enable = lib.mkForce false;
        dap-go.enable = lib.mkForce false;
        dap-python.enable = lib.mkForce false;
        dap-ui.enable = lib.mkForce false;
        dap-virtual-text.enable = lib.mkForce false;
      };
    })

    # Basic: + statusline, basic git, snacks picker for navigation
    (lib.mkIf (cfg.profile == "basic") {
      khanelivim = {
        ai = {
          provider = lib.mkForce null;
          chatEnable = lib.mkForce false;
        };

        dashboard.tool = lib.mkForce null;

        debugging = {
          adapters = lib.mkForce [ ];
          ui = lib.mkForce null;
        };

        git = {
          integrations = lib.mkForce [ "gitsigns" ];
          diffViewer = lib.mkForce null;
        };

        # No dedicated file manager - use snacks picker/explorer instead
        editor = {
          fileManager = lib.mkForce null;
          httpClient = lib.mkForce null;
          motion = lib.mkForce null;
          search = lib.mkForce null;
        };

        # Snacks picker for file navigation (<leader>ff, <leader>fe explorer)
        picker.tool = lib.mkForce "snacks";

        text = {
          comments = lib.mkForce [ "mini-comment" ];
          markdownRendering = lib.mkForce [ ];
          operators = lib.mkForce [ ];
          patterns = lib.mkForce [ ];
          splitJoin = lib.mkForce null;
          whitespace = lib.mkForce null;
        };

        # Basic UI - just statusline
        ui = {
          animations = lib.mkForce null;
          bufferline = lib.mkForce null;
          commandline = lib.mkForce null;
          indentGuides = lib.mkForce null;
          keybindingHelp = lib.mkForce null;
          notifications = lib.mkForce "snacks";
          referenceHighlighting = lib.mkForce null;
          statusColumn = lib.mkForce null;
          statusline = lib.mkForce "lualine";
          terminal = lib.mkForce [ ];
        };

        utilities = {
          clipboard = lib.mkForce [ ];
          screenshots = lib.mkForce [ ];
          sessions = lib.mkForce [ ];
        };
      };

      # Force disable plugins that nixvim modules enable by default
      plugins = {
        dap.enable = lib.mkForce false;
        dap-go.enable = lib.mkForce false;
        dap-python.enable = lib.mkForce false;
        dap-ui.enable = lib.mkForce false;
        dap-virtual-text.enable = lib.mkForce false;
      };
    })

    # Standard: Full functionality but deduplicated - no duplicate AI tools
    (lib.mkIf (cfg.profile == "standard") {
      khanelivim = {
        # Disable legacy AI provider system (we keep sidekick/claudecode)
        ai = {
          provider = lib.mkForce null;
          chatEnable = lib.mkForce false;
        };

        # Streamlined comments (no comment-box decorations)
        text.comments = lib.mkForce [
          "mini-comment"
          "ts-comments"
        ];

        # Single terminal
        ui.terminal = lib.mkForce [ "toggleterm" ];
      };

      # Force disable duplicate AI plugins (keep sidekick + claudecode tools)
      plugins = {
        avante.enable = lib.mkForce false;
        codecompanion.enable = lib.mkForce false;
        opencode.enable = lib.mkForce false;
        copilot-lua.enable = lib.mkForce false;
        copilot-chat.enable = lib.mkForce false;
        copilot-lsp.enable = lib.mkForce false;
      };
    })

    # Full: defaults (no overrides needed)
  ];
}
