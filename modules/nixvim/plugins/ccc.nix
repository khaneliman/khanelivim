{ lib, config, ... }:
{
  plugins = {
    ccc = {
      enable = true;

      lazyLoad = {
        settings = {
          cmd = "CccPick";
        };
      };

      settings = {
        highlighter = {
          auto_enable = true;
          max_byte = 2 * 1024 * 1024;
          lsp = true;
          filetypes = [ "colorPickerFts" ];
        };
        pickers = [
          # Lua
          ''require("ccc").picker.hex''
          # Lua
          ''require("ccc").picker.css_rgb''
          # Lua
          ''require("ccc").picker.css_hsl''
          # Lua
          ''
            require("ccc").picker.ansi_escape {
                            meaning1 = "bright"
                          }''
        ];
        alpha_show = "hide";
        recognize = {
          output = true;
        };
        inputs = [ "require('ccc').input.hsl" ];
        outputs = [
          # Lua
          "require('ccc').output.css_hsl"
          # Lua
          "require('ccc').output.css_rgb"
          # Lua
          "require('ccc').output.hex"
        ];
        convert = [
          [
            # Lua
            "require('ccc').picker.hex"
            # Lua
            "require('ccc').output.css_hsl"
          ]
          [
            # Lua
            "require('ccc').picker.css_rgb"
            # Lua
            "require('ccc').output.css_hsl"
          ]
          [
            # Lua
            "require('ccc').picker.css_hsl"
            # Lua
            "require('ccc').output.hex"
          ]
        ];
        mappings = {
          q.__raw = "require('ccc').mapping.quit";
          L.__raw = "require('ccc').mapping.increase10";
          H.__raw = "require('ccc').mapping.decrease10";
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.ccc.enable [
    {
      mode = "n";
      key = "<leader>up";
      action = "<cmd>CccPick<CR>";
      options = {
        desc = "Color Picker toggle";
      };
    }
  ];
}
