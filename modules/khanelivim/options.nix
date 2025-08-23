{
  lib,
  ...
}:
{
  options.khanelivim = {
    ai = {
      provider = lib.mkOption {
        type = lib.types.enum [
          "copilot"
          "windsurf"
          "none"
        ];
        default = "copilot";
        description = "AI completion provider to use";
      };

      chatEnable = lib.mkEnableOption "AI chat functionality" // {
        default = true;
      };
    };

    completion = {
      engine = lib.mkOption {
        type = lib.types.enum [
          "blink"
          "nvim-cmp"
          "none"
        ];
        default = "blink";
        description = "Completion engine to use";
      };
    };

    picker = {
      engine = lib.mkOption {
        type = lib.types.enum [
          "snacks"
          "telescope"
          "fzf"
          "none"
        ];
        default = "snacks";
        description = "Fuzzy finder/picker engine to use";
      };
    };

    performance = {
      optimizer = lib.mkOption {
        type = lib.types.enum [
          "faster"
          "snacks"
          "both"
          "none"
        ];
        default = "faster";
        description = "Performance optimization strategy for large files";
      };

      optimizeEnable =
        lib.mkEnableOption "nixvim performance optimizations (byte compilation, plugin combining)"
        // {
          default = true;
        };
    };

    loading = {
      strategy = lib.mkOption {
        type = lib.types.enum [
          "lazy"
          "eager"
        ];
        default = "lazy";
        description = "Plugin loading strategy";
      };
    };

    tasks = {
      runner = lib.mkOption {
        type = lib.types.enum [
          "overseer"
          "vs-tasks"
          "none"
        ];
        default = "overseer";
        description = "Task runner plugin to use";
      };
    };

    editor = {
      motionPlugin = lib.mkOption {
        type = lib.types.enum [
          "flash"
          "hop"
          "none"
        ];
        default = "flash";
        description = "Motion/jump plugin to use";
      };

      searchPlugin = lib.mkOption {
        type = lib.types.enum [
          "spectre"
          "grug-far"
          "none"
        ];
        default = "grug-far";
        description = "Search and replace plugin to use";
      };

      fileManager = lib.mkOption {
        type = lib.types.enum [
          "neo-tree"
          "yazi"
          "mini-files"
          "none"
        ];
        default = "yazi";
        description = "File manager plugin to use";
      };

      debugUI = lib.mkOption {
        type = lib.types.enum [
          "dap-ui"
          "dap-view"
          "none"
        ];
        default = "dap-ui";
        description = "Debug adapter UI to use";
      };

      diffViewer = lib.mkOption {
        type = lib.types.enum [
          "diffview"
          "unified"
          "mini-diff"
          "none"
        ];
        default = "unified";
        description = "Diff viewer plugin to use";
      };

      snippetEngine = lib.mkOption {
        type = lib.types.enum [
          "luasnip"
          "mini-snippets"
          "none"
        ];
        default = "mini-snippets";
        description = "Snippet engine to use";
      };

      commandlineUI = lib.mkOption {
        type = lib.types.enum [
          "noice"
          "wilder"
          "none"
        ];
        default = "noice";
        description = "Command line UI enhancement to use";
      };

      httpClient = lib.mkOption {
        type = lib.types.enum [
          "rest"
          "kulala"
          "none"
        ];
        default = "kulala";
        description = "HTTP client plugin to use";
      };
    };
  };
}
