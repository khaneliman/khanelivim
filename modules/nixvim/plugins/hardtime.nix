{ config, lib, ... }:
let
  cfg = config.plugins.hardtime;
in
{
  globals.disable_hardtime = true;

  plugins = {
    hardtime = {
      enable = true;

      # FIXME: runtime error on requiring module
      # lazyLoad.settings.cmd = "Hardtime";

      settings = {
        # NOTE: Default to off now.
        enabled = false;
        disable_mouse = false;
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.hardtime.enable [
      {
        __unkeyed-1 = "<leader>v";
        mode = "n";
        group = "Vim training";
        icon = "󱛊";
      }
    ];
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>vh";
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
        silent = true;
      };
    }
  ];
}
