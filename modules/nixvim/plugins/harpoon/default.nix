{ config, lib, ... }:
{
  plugins = {
    harpoon = {
      enable = true;

      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "<leader>ha";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():add()
            end
          '';
          desc = "Add file";
        }
        {
          __unkeyed-1 = "<leader>he";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon'.ui:toggle_quick_menu(require'harpoon':list())
            end
          '';
          desc = "Quick Menu";
        }
        {
          __unkeyed-1 = "<leader>hj";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(1)
            end
          '';
          desc = "1";
        }
        {
          __unkeyed-1 = "<leader>hk";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(2)
            end
          '';
          desc = "2";
        }
        {
          __unkeyed-1 = "<leader>hl";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(3)
            end
          '';
          desc = "3";
        }
        {
          __unkeyed-1 = "<leader>hm";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(4)
            end
          '';
          desc = "4";
        }
      ];
    };

    which-key.settings.spec = lib.optionals config.plugins.harpoon.enable [
      {
        __unkeyed-1 = "<leader>h";
        group = "Harpoon";
        icon = "󱡀 ";
      }
    ];
  };

}
