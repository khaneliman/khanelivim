{
  config,
  lib,
  ...
}:
{
  plugins = {
    claudecode = {
      enable = builtins.elem "claudecode" config.khanelivim.ai.plugins;

      settings = {
        terminal = {
          split_side = "right";
          split_width_percentage = 0.30;
        };
        focus_after_send = false;
        track_selection = true;
        diff_opts = {
          auto_close_on_accept = true;
          vertical_split = true;
          open_in_current_tab = true;
        };
      };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        settings = {
          cmd = [
            "ClaudeCode"
            "ClaudeCodeFocus"
            "ClaudeCodeSelectModel"
            "ClaudeCodeAdd"
            "ClaudeCodeSend"
            "ClaudeCodeDiffAccept"
            "ClaudeCodeDiffDeny"
          ];
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.claudecode.enable [
      {
        __unkeyed-1 = "<leader>ac";
        group = "Claude Code";
        icon = "";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.claudecode.enable [
    {
      mode = "n";
      key = "<leader>act";
      action = "<cmd>ClaudeCode<cr>";
      options = {
        desc = "Toggle Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>acc";
      action = "<cmd>ClaudeCode --continue<cr>";
      options = {
        desc = "Continue Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>acr";
      action = "<cmd>ClaudeCode --resume<cr>";
      options = {
        desc = "Resume Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>acf";
      action = "<cmd>ClaudeCodeFocus<cr>";
      options = {
        desc = "Focus Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>acm";
      action = "<cmd>ClaudeCodeSelectModel<cr>";
      options = {
        desc = "Select Claude model";
      };
    }
    {
      mode = "n";
      key = "<leader>acb";
      action = "<cmd>ClaudeCodeAdd %<cr>";
      options = {
        desc = "Add current buffer";
      };
    }
    {
      mode = "v";
      key = "<leader>acs";
      action = "<cmd>ClaudeCodeSend<cr>";
      options = {
        desc = "Send to Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>aca";
      action = "<cmd>ClaudeCodeDiffAccept<cr>";
      options = {
        desc = "Accept diff";
      };
    }
    {
      mode = "n";
      key = "<leader>acd";
      action = "<cmd>ClaudeCodeDiffDeny<cr>";
      options = {
        desc = "Deny diff";
      };
    }
  ];
}
