{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.opencode = {
    enable = lib.mkEnableOption "opencode" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "opencode" {
      default = "opencode-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for opencode";
    };

    keymaps = {
      enable = lib.mkEnableOption "default opencode keymaps" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.plugins.opencode.enable {
    plugins = {
      # Ensure snacks.nvim input is enabled (required dependency)
      snacks.settings.input.enabled = true;

      which-key.settings.spec = lib.optionals config.plugins.opencode.enable [
        {
          __unkeyed-1 = "<leader>ao";
          group = "Opencode";
          icon = "";
        }
      ];
    };

    # Enable autoread for auto_reload functionality
    opts.autoread = true;

    extraPlugins = [
      config.plugins.opencode.package
    ];

    extraConfigLua = ''
      vim.g.opencode_opts = ${lib.generators.toLua { } config.plugins.opencode.settings}
    '';

    keymaps = lib.mkIf config.plugins.opencode.keymaps.enable [
      {
        mode = "n";
        key = "<leader>aot";
        action.__raw = "function() require('opencode').toggle() end";
        options.desc = "Toggle opencode";
      }
      {
        mode = "n";
        key = "<leader>aoA";
        action.__raw = "function() require('opencode').ask() end";
        options.desc = "Ask opencode";
      }
      {
        mode = "n";
        key = "<leader>aoa";
        action.__raw = "function() require('opencode').ask('@cursor: ') end";
        options.desc = "Ask opencode about this";
      }
      {
        mode = "v";
        key = "<leader>aoa";
        action.__raw = "function() require('opencode').ask('@selection: ') end";
        options.desc = "Ask opencode about selection";
      }
      {
        mode = "n";
        key = "<leader>aon";
        action.__raw = "function() require('opencode').command('session_new') end";
        options.desc = "New opencode session";
      }
      {
        mode = "n";
        key = "<leader>aoy";
        action.__raw = "function() require('opencode').command('messages_copy') end";
        options.desc = "Copy last opencode response";
      }
      {
        mode = "n";
        key = "<S-C-u>";
        action.__raw = "function() require('opencode').command('messages_half_page_up') end";
        options.desc = "Messages half page up";
      }
      {
        mode = "n";
        key = "<S-C-d>";
        action.__raw = "function() require('opencode').command('messages_half_page_down') end";
        options.desc = "Messages half page down";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>aos";
        action.__raw = "function() require('opencode').select() end";
        options.desc = "Select opencode prompt";
      }
      {
        mode = "n";
        key = "<leader>aoe";
        action.__raw = "function() require('opencode').prompt('Explain @cursor and its context') end";
        options.desc = "Explain this code";
      }
    ];
  };
}
