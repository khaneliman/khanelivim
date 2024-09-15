{ config, lib, ... }:
{
  plugins = {
    hop = {
      enable = true;
    };
  };

  keymaps = lib.optionals config.plugins.hop.enable [
    {
      key = "f";
      action.__raw = ''
        function()
          require'hop'.hint_char1({
            direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
          })
        end
      '';
      options.remap = true;
    }
    {
      key = "F";
      action.__raw = ''
        function()
          require'hop'.hint_char1({
            direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
          })
        end
      '';
      options.remap = true;
    }
    {
      key = "t";
      action.__raw = ''
        function()
          require'hop'.hint_char1({
            direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
            hint_offset = -1
          })
        end
      '';
      options.remap = true;
    }
    {
      key = "T";
      action.__raw = ''
        function()
          require'hop'.hint_char1({
            direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
            hint_offset = 1
          })
        end
      '';
      options.remap = true;
    }
  ];
}
