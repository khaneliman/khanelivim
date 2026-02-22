{ config, lib, ... }:
{
  plugins = {
    hop = {
      # hop.nvim documentation
      # See: https://github.com/smoka7/hop.nvim
      enable = config.khanelivim.editor.motion == "hop";
    };
  };

  keymaps = lib.optionals (config.khanelivim.editor.motion == "hop") [
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
