{ config, lib, ... }:
{
  plugins = {
    harpoon = {
      enable = true;
    };

    which-key.settings.spec = lib.optionals config.plugins.harpoon.enable [
      {
        __unkeyed-1 = "<leader>h";
        group = "Harpoon";
        icon = "󱡀 ";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.harpoon.enable [
    {
      mode = "n";
      key = "<leader>ha";
      options.desc = "Add file";
      action.__raw = "function() require'harpoon':list():add() end";
    }
    {
      mode = "n";
      key = "<leader>he";
      options.desc = "Quick Menu";
      action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
    }
    {
      mode = "n";
      key = "<leader>hj";
      options.desc = "1";
      action.__raw = "function() require'harpoon':list():select(1) end";
    }
    {
      mode = "n";
      key = "<leader>hk";
      options.desc = "2";
      action.__raw = "function() require'harpoon':list():select(2) end";
    }
    {
      mode = "n";
      key = "<leader>hl";
      options.desc = "3";
      action.__raw = "function() require'harpoon':list():select(3) end";
    }
    {
      mode = "n";
      key = "<leader>hm";
      options.desc = "4";
      action.__raw = "function() require'harpoon':list():select(4) end";
    }
  ];
}
