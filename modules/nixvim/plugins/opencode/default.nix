{
  config,
  lib,
  ...
}:
{
  plugins = {
    opencode = {
      # opencode.nvim documentation
      # See: https://github.com/sudo-tee/opencode.nvim
      enable = builtins.elem "opencode" config.khanelivim.ai.plugins;

      settings = {
        auto_reload = true;
      }
      // lib.optionalAttrs config.plugins.snacks.enable {
        server.__raw = ''
          (function()
            local opencode_cmd = "opencode --port"
            local snacks_terminal_opts = {
              win = {
                position = "right",
                enter = true,
                on_win = function(win)
                  require("opencode.terminal").setup(win.win)
                end,
              },
            }

            return {
              start = function()
                require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
              end,
              stop = function()
                local terminal = require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts)
                if terminal then
                  terminal:close()
                end
              end,
              toggle = function()
                require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
              end,
            }
          end)()
        '';
      };
    };

    # TODO: check if actually required and upstream
    # Ensure snacks.nvim input is enabled (required dependency)
    snacks.settings.input.enabled = lib.mkIf config.plugins.snacks.enable true;

    which-key.settings.spec = lib.optionals config.plugins.opencode.enable [
      {
        __unkeyed-1 = "<leader>ao";
        group = "Opencode";
        icon = "";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.opencode.enable [
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
}
