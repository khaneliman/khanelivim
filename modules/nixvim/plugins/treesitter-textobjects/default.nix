{ config, lib, ... }:
let
  cfg = config.plugins.treesitter-textobjects;

  hasMiniAi = config.plugins.mini-ai.enable;
in
{
  plugins.treesitter-textobjects = {
    # nvim-treesitter-textobjects documentation
    # See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    enable = lib.elem "treesitter-textobjects" config.khanelivim.editor.textObjects;

    settings = {
      # Disable 'select' if mini-ai is enabled to avoid conflict on 'a'/'i' keys
      select = {
        enable = !hasMiniAi;
        lookahead = true;
        selection_modes = {
          "@parameter.outer" = "v";
          "@function.outer" = "V";
        };
      };

      move = {
        enable = true;
        set_jumps = true;

        goto_next_start = {
          "]m" = "@function.outer";
          "]c" = "@class.outer";
          "]o" = {
            query = "@loop.*";
            query_group = "textobjects";
          };
          "]s" = {
            query = "@local.scope";
            query_group = "locals";
          };
          "]z" = {
            query = "@fold";
            query_group = "folds";
          };
        };
        goto_next_end = {
          "]M" = "@function.outer";
          "]C" = "@class.outer";
        };
        goto_previous_start = {
          "[m" = "@function.outer";
          "[c" = "@class.outer";
          "[o" = {
            query = "@loop.*";
            query_group = "textobjects";
          };
        };
        goto_previous_end = {
          "[M" = "@function.outer";
          "[C" = "@class.outer";
        };
      };
    };
  };

  keymaps =
    let
      # Only create select mappings if NOT handled by mini-ai
      selectMaps = lib.optionals (!hasMiniAi) (
        let
          mkSelect = key: query: group: {
            mode = [
              "x"
              "o"
            ];
            inherit key;
            action.__raw = "function() require('nvim-treesitter-textobjects.select').select_textobject('${query}', '${group}') end";
          };
        in
        [
          (mkSelect "am" "@function.outer" "textobjects")
          (mkSelect "im" "@function.inner" "textobjects")
          (mkSelect "ac" "@class.outer" "textobjects")
          (mkSelect "ic" "@class.inner" "textobjects")
          (mkSelect "as" "@local.scope" "locals")
        ]
      );

      mkSwap = key: func: query: desc: {
        mode = "n";
        inherit key;
        options.desc = desc;
        action.__raw = "function() require('nvim-treesitter-textobjects.swap').${func}('${query}') end";
      };

      # Repeatable move bindings
      repeatMaps = [
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
          # ',' conflicts with Window Up (<C-W>k) map. Using Backspace as safe fallback.
          key = "<BS>";
          action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_previous";
        }
      ];

      # 'f' / 't' functionality (if flash is disabled)
      ftMaps = lib.optionals (cfg.enable && !config.plugins.flash.enable) [
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
    in
    lib.optionals cfg.enable (
      selectMaps
      ++ repeatMaps
      ++ ftMaps
      ++ [
        # Swap (Always useful, no major conflicts with standard mini plugins)
        (mkSwap "<leader>k" "swap_next" "@parameter.inner" "Swap next parameter")
        (mkSwap "<leader>K" "swap_previous" "@parameter.outer" "Swap previous parameter")
      ]
    );
}
