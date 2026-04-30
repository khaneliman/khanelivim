{ lib, config, ... }:
let
  inherit (lib.attrsets) recursiveUpdate;
  cfg = config.khanelivim;
  mkDefaultAttrs = lib.mapAttrs (_: lib.mkDefault);

  minimalProfile = {
    khanelivim = {
      ai = mkDefaultAttrs {
        plugins = [ ];
        chatEnable = false;
      };

      dashboard.tool = lib.mkDefault null;
      documentation.viewers = lib.mkDefault [ ];

      debugging = mkDefaultAttrs {
        adapters = [ ];
        ui = null;
      };

      git = mkDefaultAttrs {
        integrations = [ ];
        diffViewer = null;
      };

      editor = mkDefaultAttrs {
        fileManager = null;
        httpClient = null;
        motion = null;
        rename = null;
        search = null;
        textObjects = [ ];
      };

      picker.tool = lib.mkDefault null;

      text = mkDefaultAttrs {
        comments = [ ];
        markdownRendering = [ ];
        operators = [ ];
        patterns = [ ];
        splitJoin = null;
        whitespace = null;
      };

      ui = mkDefaultAttrs {
        animations = null;
        bufferline = null;
        commandline = null;
        indentGuides = null;
        keybindingHelp = null;
        notifications = "snacks";
        referenceHighlighting = null;
        renamePopup = null;
        signatureHelp = null;
        statusColumn = null;
        statusline = null;
        terminal = [ ];
      };

      utilities = mkDefaultAttrs {
        clipboard = [ ];
        screenshots = [ ];
        sessions = [ ];
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
      editor = mkDefaultAttrs {
        fileManager = "yazi";
        motion = "flash";
        textObjects = [ "mini-ai" ];
      };

      git.integrations = lib.mkDefault [ "gitsigns" ];
      jj.integrations = lib.mkDefault [ "jjsigns" ];
      picker.tool = lib.mkDefault "snacks";

      text.comments = lib.mkDefault [ "ts-comments" ];

      ui = mkDefaultAttrs {
        keybindingHelp = "which-key";
        statusline = "lualine";
        terminal = [ "snacks" ];
      };
    };
  };

  standardProfile = recursiveUpdate basicProfile {
    khanelivim = {
      ai = mkDefaultAttrs {
        plugins = [
          "sidekick"
          "copilot"
          "copilot-lsp"
        ];
        chatEnable = false;
      };

      dashboard.tool = lib.mkDefault "mini-starter";
      documentation.viewers = lib.mkDefault [ "helpview" ];

      debugging = mkDefaultAttrs {
        adapters = [
          "dap"
          "debugprint"
        ];
        ui = "dap-view";
      };

      editor = mkDefaultAttrs {
        rename = "inc-rename";
        search = "grug-far";
      };

      git = mkDefaultAttrs {
        diffViewer = "codediff";
        integrations = [
          "gitsigns"
          "git-conflict"
          "git-worktree"
          "snacks-gitbrowse"
          "snacks-lazygit"
        ];
      };

      jj.integrations = [
        "jj"
        "jjsigns"
      ];

      text = mkDefaultAttrs {
        markdownRendering = [ "markview" ];
        splitJoin = "mini-splitjoin";
        patterns = [ "todo-comments" ];
        whitespace = "mini-trailspace";
      };

      ui = mkDefaultAttrs {
        bufferline = "bufferline";
        commandline = "noice";
        indentGuides = "blink-indent";
        notifications = "noice";
        renamePopup = "snacks";
        statusColumn = "snacks";
      };

      utilities = mkDefaultAttrs {
        clipboard = [ "yanky" ];
        screenshots = [ "codesnap" ];
        sessions = [ "persistence" ];
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

      plugins = {
        copilot-lua.settings.logger = {
          file_log_level = lib.mkForce (lib.nixvim.mkRaw "vim.log.levels.TRACE");
          print_log_level = lib.mkForce (lib.nixvim.mkRaw "vim.log.levels.DEBUG");
          trace_lsp = lib.mkForce "verbose";
          trace_lsp_progress = lib.mkForce true;
          log_lsp_messages = lib.mkForce true;
        };

        easy-dotnet.settings.server.log_level = lib.mkForce "Verbose";

        fidget.settings.logger.level = lib.mkForce "debug";

        kulala.settings.debug = lib.mkForce true;

        overseer.settings.log_level = lib.mkForce (lib.nixvim.mkRaw "vim.log.levels.TRACE");

        typescript-tools.settings.settings.tsserver_logs = lib.mkForce "verbose";
      };

      extraConfigVim = ''
        set verbose=9
        set verbosefile=~/.cache/nvim/debug.log
      '';

      extraConfigLua = ''
        -- Enable LSP debug logging
        vim.lsp.log.set_level(vim.lsp.log.levels.DEBUG)

        -- Notify when debug profile is active
        vim.notify("DEBUG profile active - all optimizations disabled", vim.log.levels.WARN)
        vim.notify("Logs: ~/.cache/nvim/debug.log and ~/.local/state/nvim/lsp.log", vim.log.levels.INFO)
      '';
    })
  ];
}
