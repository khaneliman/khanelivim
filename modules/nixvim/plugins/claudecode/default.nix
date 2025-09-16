{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.claudecode = {
    enable = lib.mkEnableOption "claudecode" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "claudecode" {
      default = "claudecode-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
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
      description = "Configuration for claudecode";
    };
  };

  config =
    let
      luaConfig = ''
        require('claudecode').setup(${lib.generators.toLua { } config.plugins.claudecode.settings})
      '';
    in
    lib.mkIf config.plugins.claudecode.enable {
      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      extraPlugins = [
        {
          plugin = config.plugins.claudecode.package;
          optional = config.plugins.lz-n.enable;
        }
      ];

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "claudecode.nvim";
              cmd = [
                "ClaudeCode"
                "ClaudeCodeFocus"
                "ClaudeCodeSelectModel"
                "ClaudeCodeAdd"
                "ClaudeCodeSend"
                "ClaudeCodeDiffAccept"
                "ClaudeCodeDiffDeny"
              ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };

        which-key.settings.spec = lib.optionals config.plugins.claudecode.enable [
          {
            __unkeyed-1 = "<leader>ac";
            group = "Claude Code";
            icon = "";
          }
        ];
      };

      keymaps = [
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
    };
}
