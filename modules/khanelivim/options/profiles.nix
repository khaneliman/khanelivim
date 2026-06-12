{ lib, config, ... }:
let
  inherit (lib.attrsets) recursiveUpdate;
  cfg = config.khanelivim;
  mkDefaultAttrs = lib.mapAttrs (_: lib.mkDefault);
  mkProfileOverride = lib.mkOverride 900;
  mkProfileEnable = mkProfileOverride true;
  mkProfileDisable = mkProfileOverride false;
  mkPluginGateAttrs =
    enabled:
    lib.genAttrs leanGatedPluginNames (_: {
      enable = enabled;
    });
  mkPluginGateProfile =
    enabled:
    recursiveUpdate (mkPluginGateAttrs enabled) {
      conform-nvim.autoInstall.enable = enabled;
      lint.autoInstall.enable = enabled;
    };

  leanGatedPluginNames = [
    "ccc"
    "colorizer"
    "conform-nvim"
    "direnv"
    "easy-dotnet"
    "endec"
    "fastaction"
    "fff"
    "firenvim"
    "friendly-snippets"
    "gitignore"
    "hardtime"
    "harpoon"
    "iron"
    "lazydev"
    "leetcode"
    "lensline"
    "lint"
    "mini-align"
    "mini-basics"
    "mini-bracketed"
    "mini-fuzzy"
    "mini-git"
    "mini-icons"
    "mini-map"
    "mini-surround"
    "multicursor"
    "navic"
    "neoconf"
    "neogen"
    "neorg"
    "neotest"
    "nix"
    "nix-develop"
    "nvim-lightbulb"
    "package-info"
    "patterns"
    "precognition"
    "refactoring"
    "rustowl"
    "showkeys"
    "sleuth"
    "smartcolumn"
    "snacks"
    "sqlite-lua"
    "treesitter"
    "treesitter-context"
    "treesitter-modules"
    "tuis"
    "venv-selector"
    "vim-suda"
  ];

  minimalProfile = {
    khanelivim = {
      ai = mkDefaultAttrs {
        plugins = [ ];
        chatEnable = false;
      };

      completion.tool = lib.mkDefault "native";
      dashboard.tool = lib.mkDefault null;
      documentation.viewers = lib.mkDefault [ ];

      debugging = mkDefaultAttrs {
        adapters = [ ];
        ui = null;
      };

      git = mkDefaultAttrs {
        integrations = [ "native-difftool" ];
        diffViewer = null;
      };

      integrations.accountBacked = {
        enable = lib.mkDefault false;
        ai.enable = lib.mkDefault false;
        timeTracking.enable = lib.mkDefault false;
      };

      jj.integrations = lib.mkDefault [ ];

      lsp = mkDefaultAttrs {
        csharp = "roslyn_ls";
        diagnosticsViewer = "native";
        java = "java-language-server";
        navigation = "native";
        rust = "rust-analyzer";
        typescript = "ts_ls";
      };

      editor = mkDefaultAttrs {
        autopairs = null;
        fileManager = null;
        httpClient = null;
        motion = null;
        movement = null;
        rename = null;
        search = null;
        textObjects = [ ];
      };

      performance.optimizer = lib.mkDefault [ ];

      picker.tool = lib.mkDefault null;

      tasks.tool = lib.mkDefault null;

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
        bufferDelete = null;
        bufferline = null;
        commandline = "ui2";
        indentGuides = null;
        keybindingHelp = null;
        notifications = "native";
        referenceHighlighting = null;
        renamePopup = null;
        signatureHelp = null;
        statusColumn = null;
        statusline = null;
        terminal = [ ];
        zenMode = null;
      };

      utilities = mkDefaultAttrs {
        clipboard = [ ];
        screenshots = [ ];
        sessions = [ ];
        undoTree = "native";
      };
    };

    plugins = recursiveUpdate (mkPluginGateProfile mkProfileDisable) {
      dap.enable = mkProfileDisable;
      dap-go.enable = mkProfileDisable;
      dap-python.enable = mkProfileDisable;
      dap-ui.enable = mkProfileDisable;
      dap-virtual-text.enable = mkProfileDisable;
    };
  };

  basicProfile = recursiveUpdate minimalProfile {
    khanelivim = {
      editor = mkDefaultAttrs {
        fileManager = "yazi";
        motion = "flash";
        textObjects = [ "mini-ai" ];
      };

      git.integrations = lib.mkDefault [
        "gitsigns"
        "native-difftool"
      ];
      picker.tool = lib.mkDefault "snacks";

      text.comments = lib.mkDefault [ "ts-comments" ];

      utilities.undoTree = lib.mkDefault "native";
    };

    plugins = {
      snacks.enable = mkProfileEnable;
      treesitter.enable = mkProfileEnable;
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

      completion.tool = lib.mkDefault "blink";
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
        autopairs = "mini-pairs";
        fileManager = "yazi";
        motion = "flash";
        movement = "mini-move";
        rename = "inc-rename";
        search = "grug-far";
        textObjects = [ "mini-ai" ];
      };

      git = mkDefaultAttrs {
        diffViewer = "codediff";
        integrations = [
          "gitsigns"
          "git-conflict"
          "git-worktree"
          "hunk"
          "native-difftool"
          "octo"
          "snacks-gh"
          "snacks-gitbrowse"
          "snacks-lazygit"
        ];
      };

      integrations.accountBacked = {
        enable = lib.mkDefault true;
        ai.enable = lib.mkDefault true;
        timeTracking.enable = lib.mkDefault true;
      };

      jj.integrations = [
        "jj"
        "jjsigns"
      ];

      lsp = mkDefaultAttrs {
        csharp = "roslyn";
        diagnosticsViewer = "trouble";
        java = "nvim-java";
        navigation = "glance";
        rust = "rustaceanvim";
        typescript = "typescript-tools";
      };

      performance.optimizer = lib.mkDefault [ "faster" ];

      tasks.tool = lib.mkDefault "overseer";

      text = mkDefaultAttrs {
        markdownRendering = [ "markview" ];
        splitJoin = "mini-splitjoin";
        patterns = [ "todo-comments" ];
        whitespace = "mini-trailspace";
      };

      ui = mkDefaultAttrs {
        animations = "snacks";
        bufferDelete = "snacks";
        bufferline = "bufferline";
        commandline = "noice";
        indentGuides = "blink-indent";
        keybindingHelp = "which-key";
        notifications = "noice";
        referenceHighlighting = "snacks-words";
        renamePopup = "snacks";
        signatureHelp = "blink";
        statusColumn = "snacks";
        statusline = "lualine";
        terminal = [ "snacks" ];
        zenMode = "snacks";
      };

      utilities = mkDefaultAttrs {
        clipboard = [ "yanky" ];
        screenshots = [ "codesnap" ];
        sessions = [ "persistence" ];
        undoTree = "native";
      };
    };

    plugins = mkPluginGateProfile mkProfileEnable;
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

      - minimal: native-first base with LSP, native completion/UI, and minimal plugins
      - basic: lean daily-lite profile with yazi, snacks picker, flash, gitsigns, and treesitter
      - standard: Recommended developer default with AI, git, debugging, search, and core UI
      - full: khaneliman's maximal daily configuration. Applies no overrides at
        all; every khanelivim option keeps its declared default, which is the
        everything-enabled setup the other profiles trim down from.
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

    # Full: intentionally no block. The declared option defaults ARE the full
    # configuration; the other profiles exist to pare it down.

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
