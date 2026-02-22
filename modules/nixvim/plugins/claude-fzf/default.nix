{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.claude-fzf = {
    enable = lib.mkEnableOption "claude-fzf" // {
      default = config.plugins.claudecode.enable;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "claude-fzf" {
      default = "claude-fzf-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        keymaps = {
          files = "<leader>acF";
          grep = "<leader>acg";
          buffers = "<leader>acB";
          git_files = "<leader>acG";
          directory_files = "<leader>acD";
        };

        fzf_opts = {
          preview = {
            border = "rounded";
          };
          winopts = {
            width = 0.7;
          };
        };

        logging.level = "WARN";
      };
      description = "Configuration for claude-fzf";
    };
  };

  config = lib.mkIf config.plugins.claude-fzf.enable {
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "claude-fzf.nvim";
        keys = [
          {
            __unkeyed-1 = "<leader>acF";
            desc = "Claude Files";
          }
          {
            __unkeyed-1 = "<leader>acg";
            desc = "Claude Grep";
          }
          {
            __unkeyed-1 = "<leader>acB";
            desc = "Claude Buffers";
          }
          {
            __unkeyed-1 = "<leader>acG";
            desc = "Claude Git Files";
          }
          {
            __unkeyed-1 = "<leader>acD";
            desc = "Claude Directory Files";
          }
        ];
        after.__raw = ''
          function()
            require('claude-fzf').setup(${lib.generators.toLua { } config.plugins.claude-fzf.settings})
          end
        '';
      }
    ];

    extraPlugins = [
      {
        plugin = config.plugins.claude-fzf.package;
        optional = true;
      }
    ];
  };
}
