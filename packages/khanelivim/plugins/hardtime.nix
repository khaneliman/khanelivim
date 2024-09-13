{ config, lib, ... }:
let
  cfg = config.plugins.hardtime;
in
{
  plugins = {
    hardtime = {
      enable = true;

      settings = {
        enabled = true;
        disable_mouse = false;
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.hardtime.enable [
      {
        __unkeyed = "<leader>H";
        mode = "n";
        desc = "Hardtime";
        icon = "󰖵";
      }
    ];
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>Ht";
      action.__raw = ''
        function ()
          vim.g.disable_hardtime = not vim.g.disable_hardtime
          if vim.g.disable_hardtime then
            require("hardtime").disable()
          else
            require("hardtime").enable()
          end
          vim.notify(string.format("Hardtime %s", bool2str(not vim.g.disable_hardtime), "info"))
        end
      '';
      options = {
        desc = "Hardtime toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>He";
      action = "<cmd>Hardtime enable<cr>";
      options = {
        desc = "Hardtime enable";
      };
    }
    {
      mode = "n";
      key = "<leader>Hd";
      action = "<cmd>Hardtime disable<cr>";
      options = {
        desc = "Hardtime disable";
      };
    }
  ];
}
