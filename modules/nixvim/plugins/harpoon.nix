{ config, lib, ... }:
{
  plugins = {
    harpoon = {
      enable = true;

      keymapsSilent = true;

      keymaps = {
        addFile = "<leader>ha";
        toggleQuickMenu = "<leader>he";
        navFile = {
          "1" = "<leader>hj";
          "2" = "<leader>hk";
          "3" = "<leader>hl";
          "4" = "<leader>hm";
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.harpoon.enable [
      {
        __unkeyed = "<leader>h";
        group = "Harpoon";
        icon = "󱡀 ";
      }
      {
        __unkeyed = "<leader>ha";
        desc = "Add";
      }
      {
        __unkeyed = "<leader>he";
        desc = "QuickMenu";
      }
      {
        __unkeyed = "<leader>hj";
        desc = "1";
      }
      {
        __unkeyed = "<leader>hk";
        desc = "2";
      }
      {
        __unkeyed = "<leader>hl";
        desc = "3";
      }
      {
        __unkeyed = "<leader>hm";
        desc = "4";
      }
    ];
  };
}
