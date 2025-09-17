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
      default = true;
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
      description = "Configuration for claude-fzf-history";
    };
  };

  config = lib.mkIf config.plugins.claude-fzf-history.enable {
    extraPlugins = [
      config.plugins.claude-fzf-history.package
    ];

    extraConfigLua = ''
      require('claude-fzf-history').setup(${
        lib.generators.toLua { } config.plugins.claude-fzf-history.settings
      })
    '';

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
