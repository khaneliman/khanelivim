{ config, lib, ... }:
{
  plugins = {
    harpoon = {
      enable = true;

      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "<leader>Ha";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():add()
            end
          '';
          desc = "Add file";
        }
        {
          __unkeyed-1 = "<leader>He";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon'.ui:toggle_quick_menu(require'harpoon':list())
            end
          '';
          desc = "Quick Menu";
        }
        {
          __unkeyed-1 = "<leader>Hj";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(1)
            end
          '';
          desc = "1";
        }
        {
          __unkeyed-1 = "<leader>Hk";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(2)
            end
          '';
          desc = "2";
        }
        {
          __unkeyed-1 = "<leader>Hl";
          __unkeyed-2.__raw = ''
            function()
              require'harpoon':list():select(3)
            end
          '';
          desc = "3";
        }
        {
          __unkeyed-1 = "<leader>Hm";
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
        __unkeyed-1 = "<leader>H";
        group = "Harpoon";
        icon = "󱡀 ";
      }
    ];
  };

}
