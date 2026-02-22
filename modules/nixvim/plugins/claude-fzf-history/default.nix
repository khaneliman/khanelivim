{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.claude-fzf-history = {
    enable = lib.mkEnableOption "claude-fzf-history" // {
      default = config.plugins.claudecode.enable;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "claude-fzf-history" {
      default = "claude-fzf-history-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        preview = {
          position = "right:60%";
          wrap = true;
          syntax_highlighting = {
            theme = "Catppuccin Macchiato";
            language = "markdown";
            show_line_numbers = false;
          };
        };

        logging.level = "WARN";
      };
      description = ''
        Configuration for claude-fzf-history.

        See <https://github.com/pittcat/claude-fzf-history.nvim>
      '';
    };
  };

  config = lib.mkIf config.plugins.claude-fzf-history.enable {
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "claude-fzf-history.nvim";
        cmd = [ "ClaudeHistory" ];
        after.__raw = ''
          function()
            require('claude-fzf-history').setup(${
              lib.generators.toLua { } config.plugins.claude-fzf-history.settings
            })
          end
        '';
      }
    ];

    extraPlugins = [
      {
        plugin = config.plugins.claude-fzf-history.package;
        optional = true;
      }
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>ach";
        action = "<cmd>ClaudeHistory<CR>";
        options = {
          desc = "Claude History";
          silent = true;
        };
      }
    ];
  };
}
