{ config, lib, ... }:
{
  plugins.mini-clue = lib.mkIf (config.khanelivim.ui.keybindingHelp == "mini-clue") {
    enable = true;
    settings = {
      triggers = [
        # Leader triggers
        {
          mode = "n";
          keys = "<Leader>";
        }
        {
          mode = "x";
          keys = "<Leader>";
        }

        # Built-in completion
        {
          mode = "i";
          keys = "<C-x>";
        }

        # `g` key
        {
          mode = "n";
          keys = "g";
        }
        {
          mode = "x";
          keys = "g";
        }

        # Marks
        {
          mode = "n";
          keys = "'";
        }
        {
          mode = "n";
          keys = "`";
        }
        {
          mode = "x";
          keys = "'";
        }
        {
          mode = "x";
          keys = "`";
        }

        # Registers
        {
          mode = "n";
          keys = ''"'';
        }
        {
          mode = "x";
          keys = ''"'';
        }
        {
          mode = "i";
          keys = "<C-r>";
        }
        {
          mode = "c";
          keys = "<C-r>";
        }

        # Window commands
        {
          mode = "n";
          keys = "<C-w>";
        }

        # mini.basics toggles
        {
          mode = "n";
          keys = "\\";
        }

        # `z` key
        {
          mode = "n";
          keys = "z";
        }
        {
          mode = "x";
          keys = "z";
        }

        # Bracketed
        {
          mode = "n";
          keys = "[";
        }
        {
          mode = "x";
          keys = "[";
        }
        {
          mode = "n";
          keys = "]";
        }
        {
          mode = "x";
          keys = "]";
        }
      ];

      clues = [
        # Enhance this by adding descriptions for <Leader> mapping groups
        {
          __raw = "require('mini.clue').gen_clues.builtin_completion()";
        }
        {
          __raw = "require('mini.clue').gen_clues.g()";
        }
        {
          __raw = "require('mini.clue').gen_clues.marks()";
        }
        {
          __raw = "require('mini.clue').gen_clues.registers()";
        }
        {
          __raw = "require('mini.clue').gen_clues.square_brackets()";
        }
        {
          __raw = "require('mini.clue').gen_clues.windows({ submode_resize = true })";
        }
        {
          __raw = "require('mini.clue').gen_clues.z()";
        }
      ];
    };
  };
}
