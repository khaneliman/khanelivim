{ config, lib, ... }:
let
  mkSelect = key: query: group: {
    mode = [
      "x"
      "o"
    ];
    inherit key;
    action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('${query}', '${group}') end";
  };

  mkSwap = key: func: query: desc: {
    mode = "n";
    inherit key;
    options.desc = desc;
    action.__raw = "function() require('nvim-treesitter-textobjects.swap').${func}('${query}') end";
  };

  mkMove = key: func: query: group: {
    mode = [
      "n"
      "x"
      "o"
    ];
    inherit key;
    action.__raw = "function() require('nvim-treesitter-textobjects.move').${func}('${query}', '${group}') end";
  };

  mkMoveRaw = key: func: query: group: {
    mode = [
      "n"
      "x"
      "o"
    ];
    inherit key;
    action.__raw = "function() require('nvim-treesitter-textobjects.move').${func}(${query}, '${group}') end";
  };
in
{
  plugins.treesitter-textobjects = {
    enable = lib.elem "treesitter-textobjects" config.khanelivim.editor.textObjects;

    settings = {
      select = {
        lookahead = true;
        selection_modes = {
          "@parameter.outer" = "v";
          "@function.outer" = "V";
        };
      };
      move = {
        set_jumps = true;
      };
    };
  };

  keymaps =
    lib.optionals config.plugins.treesitter-textobjects.enable [
      # Select
      (mkSelect "am" "@function.outer" "textobjects")
      (mkSelect "im" "@function.inner" "textobjects")
      (mkSelect "ac" "@class.outer" "textobjects")
      (mkSelect "ic" "@class.inner" "textobjects")
      (mkSelect "as" "@local.scope" "locals")

      # Swap
      (mkSwap "<leader>k" "swap_next" "@parameter.inner" "Swap next parameter")
      (mkSwap "<leader>K" "swap_previous" "@parameter.outer" "Swap previous parameter")

      # Move
      (mkMove "]m" "goto_next_start" "@function.outer" "textobjects")
      (mkMove "]]" "goto_next_start" "@class.outer" "textobjects")
      (mkMoveRaw "]o" "goto_next_start" "{ \"@loop.inner\", \"@loop.outer\" }" "textobjects")
      (mkMove "]s" "goto_next_start" "@local.scope" "locals")
      (mkMove "]z" "goto_next_start" "@fold" "folds")

      (mkMove "]M" "goto_next_end" "@function.outer" "textobjects")
      (mkMove "][" "goto_next_end" "@class.outer" "textobjects")

      (mkMove "[m" "goto_previous_start" "@function.outer" "textobjects")
      (mkMove "[[" "goto_previous_start" "@class.outer" "textobjects")

      (mkMove "[M" "goto_previous_end" "@function.outer" "textobjects")
      (mkMove "[]" "goto_previous_end" "@class.outer" "textobjects")

      # Conflict with mini-bracketed (diagnostics)
      # (mkMove "]d" "goto_next" "@conditional.outer" "textobjects")
      # (mkMove "[d" "goto_previous" "@conditional.outer" "textobjects")

      # Repeatable
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = ";";
        action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_next";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = ",";
        action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_previous";
      }
    ]
    ++ lib.optionals (config.plugins.treesitter-textobjects.enable && !config.plugins.flash.enable) [
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "f";
        action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').builtin_f_expr";
        options.expr = true;
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "F";
        action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').builtin_F_expr";
        options.expr = true;
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "t";
        action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').builtin_t_expr";
        options.expr = true;
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "T";
        action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').builtin_T_expr";
        options.expr = true;
      }
    ];
}
