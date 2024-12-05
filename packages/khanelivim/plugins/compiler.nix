{ config, lib, ... }:
{
  plugins = {
    compiler = {
      enable = true;

      lazyLoad = {
        settings = {
          keys = [
            {
              __unkeyed-1 = "<leader>Ro";
              __unkeyed-2 = "<cmd>CompilerOpen<CR>";
              desc = "Compiler Open";
            }
            {
              __unkeyed-1 = "<leader>Rr";
              __unkeyed-2 = "<cmd>CompilerRedo<CR>";
              desc = "Compiler Redo";
            }
            {
              __unkeyed-1 = "<leader>Rs";
              __unkeyed-2 = "<cmd>CompilerStop<CR>";
              desc = "Compiler Stop";
            }
            {
              __unkeyed-1 = "<leader>Rt";
              __unkeyed-2 = "<cmd>CompilerToggleResults<CR>";
              desc = "Compiler Toggle Results";
            }
          ];
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.compiler.enable [
      {
        __unkeyed = "<leader>R";
        group = "Compiler";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf (config.plugins.compiler.enable && !config.plugins.compiler.lazyLoad.enable) [
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
