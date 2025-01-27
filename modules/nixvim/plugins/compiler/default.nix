{ config, lib, ... }:
{
  plugins = {
    compiler = {
      enable = true;

      lazyLoad = {
        settings = {
          before.__raw = ''
            function()
              require('lz.n').trigger_load('overseer.nvim')
            end
          '';
          cmd = [
            "CompilerOpen"
            "CompilerRedo"
            "CompilerStop"
            "CompilerToggleResults"
          ];
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.compiler.enable [
      {
        __unkeyed-1 = "<leader>R";
        group = "Compiler";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.compiler.enable [
    {
      mode = "n";
      key = "<leader>Ro";
      action = "<cmd>CompilerOpen<CR>";
      options = {
        desc = "Compiler Open";
      };
    }
    {
      mode = "n";
      key = "<leader>Rr";
      action = "<cmd>CompilerRedo<CR>";
      options = {
        desc = "Compiler Redo";
      };
    }
    {
      mode = "n";
      key = "<leader>Rs";
      action = "<cmd>CompilerStop<CR>";
      options = {
        desc = "Compiler Stop";
      };
    }
    {
      mode = "n";
      key = "<leader>Rt";
      action = "<cmd>CompilerToggleResults<CR>";
      options = {
        desc = "Compiler Toggle Results";
      };
    }
  ];
}
