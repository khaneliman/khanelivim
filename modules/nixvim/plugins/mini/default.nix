{
  config,
  lib,
  ...
}:
let
  hasTreeSitterTextobjects = lib.elem "treesitter-textobjects" config.khanelivim.editor.textObjects;
in
{
  imports = [
    ./animate.nix
    ./bufremove.nix
    ./clue.nix
    ./cursorword.nix
    ./diff.nix
    ./files.nix
    ./fuzzy.nix
    ./git.nix
    ./hipatterns.nix
    ./indentscope.nix
    ./map.nix
    ./move.nix
    ./notify.nix
    ./operators.nix
    ./pairs.nix
    ./sessions.nix
    ./snippets.nix
    ./splitjoin.nix
    ./starter.nix
    ./surround.nix
    ./trailspace.nix
  ];

  # mini.nvim documentation
  # See: https://github.com/echasnovski/mini.nvim
  plugins = {
    mini-ai = {
      enable = lib.elem "mini-ai" config.khanelivim.editor.textObjects;
      settings = lib.mkIf hasTreeSitterTextobjects {
        custom_textobjects = {
          f = {
            __raw = "require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' })";
          };
          c = {
            __raw = "require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' })";
          };
        };
      };
    };

    mini-align.enable = true;

    mini-basics = {
      enable = true;
      settings = {
        # Keep core editing/LSP maps owned by khanelivim's explicit keymap layer.
        mappings.basic = false;
      };
    };

    mini-bracketed = {
      enable = true;
      settings = lib.mkMerge [
        {
          indent.suffix = "";
          quickfix.suffix = "";
        }
        (lib.mkIf hasTreeSitterTextobjects {
          comment.suffix = "";
          file.suffix = "";
        })
        (lib.mkIf config.plugins.gitsigns.enable {
          comment.suffix = "";
        })
      ];
    };

    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    mini-snippets = lib.mkIf (config.khanelivim.editor.snippet == "mini-snippets") {
      enable = true;
      settings = {
        mappings = {
          # Avoid conflicts with khanelivim's global insert-mode <C-j>/<C-k>/<C-h>/<C-l> movement maps.
          expand = "<C-g><C-j>";
          jump_next = "<C-g><C-l>";
          jump_prev = "<C-g><C-h>";
          stop = "<C-g><C-c>";
        };
        snippets = {
          __unkeyed-1.__raw = "require('mini.snippets').gen_loader.from_lang()";
        };
      };
    };
  };
}
