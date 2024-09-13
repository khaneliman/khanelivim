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
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>Ht";
      action = "<cmd>Hardtime toggle<cr>";
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
