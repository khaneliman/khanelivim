{ lib, config, ... }:
let
  inherit (lib.attrsets) recursiveUpdate;
  cfg = config.khanelivim;

  minimalProfile = {
    khanelivim = {
      ai = {
        plugins = lib.mkDefault [ ];
        chatEnable = lib.mkDefault false;
      };

      dashboard.tool = lib.mkDefault null;
      documentation.viewers = lib.mkDefault [ ];

      debugging = {
        adapters = lib.mkDefault [ ];
        ui = lib.mkDefault null;
      };

      git = {
        integrations = lib.mkDefault [ ];
        diffViewer = lib.mkDefault null;
      };

      editor = {
        fileManager = lib.mkDefault null;
        httpClient = lib.mkDefault null;
        motion = lib.mkDefault null;
        rename = lib.mkDefault null;
        search = lib.mkDefault null;
        textObjects = lib.mkDefault [ ];
      };

      picker.tool = lib.mkDefault null;

      text = {
        comments = lib.mkDefault [ ];
        markdownRendering = lib.mkDefault [ ];
        operators = lib.mkDefault [ ];
        patterns = lib.mkDefault [ ];
        splitJoin = lib.mkDefault null;
        whitespace = lib.mkDefault null;
      };

      ui = {
        animations = lib.mkDefault null;
        bufferline = lib.mkDefault null;
        commandline = lib.mkDefault null;
        indentGuides = lib.mkDefault null;
        keybindingHelp = lib.mkDefault null;
        notifications = lib.mkDefault "snacks";
        referenceHighlighting = lib.mkDefault null;
        renamePopup = lib.mkDefault null;
        signatureHelp = lib.mkDefault null;
        statusColumn = lib.mkDefault null;
        statusline = lib.mkDefault null;
        terminal = lib.mkDefault [ ];
      };

      utilities = {
        clipboard = lib.mkDefault [ ];
        screenshots = lib.mkDefault [ ];
        sessions = lib.mkDefault [ ];
      };
    };

    plugins = {
      dap.enable = lib.mkDefault false;
      dap-go.enable = lib.mkDefault false;
      dap-python.enable = lib.mkDefault false;
      dap-ui.enable = lib.mkDefault false;
      dap-virtual-text.enable = lib.mkDefault false;
    };
  };

  basicProfile = recursiveUpdate minimalProfile {
    khanelivim = {
      editor = {
        fileManager = lib.mkDefault "yazi";
        motion = lib.mkDefault "flash";
        textObjects = lib.mkDefault [ "mini-ai" ];
      };

      git.integrations = lib.mkDefault [ "gitsigns" ];
      picker.tool = lib.mkDefault "snacks";

      text.comments = lib.mkDefault [ "ts-comments" ];

      ui = {
        keybindingHelp = lib.mkDefault "which-key";
        notifications = lib.mkDefault "snacks";
        statusline = lib.mkDefault "lualine";
        terminal = lib.mkDefault [ "snacks" ];
      };
    };
  };

  standardProfile = recursiveUpdate basicProfile {
    khanelivim = {
      ai = {
        plugins = lib.mkDefault [
          "sidekick"
          "copilot"
          "copilot-lsp"
        ];
        chatEnable = lib.mkDefault false;
      };

      dashboard.tool = lib.mkDefault "mini-starter";
      documentation.viewers = lib.mkDefault [ "helpview" ];

      debugging = {
        adapters = lib.mkDefault [
          "dap"
          "dap-virtual-text"
          "debugprint"
        ];
        ui = lib.mkDefault "dap-ui";
      };

      editor = {
        rename = lib.mkDefault "inc-rename";
        search = lib.mkDefault "grug-far";
      };

      git = {
        diffViewer = lib.mkDefault "codediff";
        integrations = lib.mkDefault [
          "gitsigns"
          "git-conflict"
          "git-worktree"
          "snacks-gitbrowse"
          "snacks-lazygit"
        ];
      };

      text = {
        markdownRendering = lib.mkDefault [ "markview" ];
        splitJoin = lib.mkDefault "mini-splitjoin";
        patterns = lib.mkDefault [ "todo-comments" ];
        whitespace = lib.mkDefault "mini-trailspace";
      };

      ui = {
        bufferline = lib.mkDefault "bufferline";
        commandline = lib.mkDefault "noice";
        indentGuides = lib.mkDefault "blink-indent";
        renamePopup = lib.mkDefault "snacks";
        statusColumn = lib.mkDefault "snacks";
      };

      utilities = {
        clipboard = lib.mkDefault [ "yanky" ];
        screenshots = lib.mkDefault [ "codesnap" ];
        sessions = lib.mkDefault [ "persistence" ];
      };
    };
  };
in
{
  options.khanelivim.profile = lib.mkOption {
    type = lib.types.enum [
      "minimal"
      "basic"
      "standard"
      "full"
      "debug"
    ];
    default = "standard";
    description = ''
      Configuration profile preset.

      - minimal: Native-lean base with LSP, treesitter, blink, and minimal UI
      - basic: Lean daily driver with yazi, snacks picker, flash, gitsigns, and lualine
      - standard: Recommended developer default with AI, git, debugging, search, and core UI
      - full: Everything enabled, including optional and overlapping workflows
      - debug: Full profile with performance optimizations disabled and debug logging enabled
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.profile == "minimal") (
      recursiveUpdate minimalProfile {
        khanelivim.performance.treesitter.whitelistMode = lib.mkDefault true;
      }
    ))
    (lib.mkIf (cfg.profile == "basic") basicProfile)
    (lib.mkIf (cfg.profile == "standard") standardProfile)

    # Debug: full profile with performance optimizations disabled and debug logging enabled
    (lib.mkIf (cfg.profile == "debug") {
      khanelivim = {
        performance = {
          optimizeEnable = lib.mkForce false;
          optimizer = lib.mkForce [ ];
        };
      };

      globals = {
        log_level = "debug";
      };

      extraConfigVim = ''
        set verbose=9
        set verbosefile=~/.cache/nvim/debug.log
      '';

      extraConfigLua = ''
        -- Enable LSP debug logging
        vim.lsp.set_log_level("DEBUG")

        -- Notify when debug profile is active
        vim.notify("DEBUG profile active - all optimizations disabled", vim.log.levels.WARN)
        vim.notify("Logs: ~/.cache/nvim/debug.log and ~/.local/state/nvim/lsp.log", vim.log.levels.INFO)
      '';
    })
  ];
}
