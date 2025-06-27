{ config, lib, ... }:
{
  plugins.toggleterm = {
    enable = true;

    lazyLoad = {
      settings = {
        cmd = "ToggleTerm";
        keys = [
          "<leader>gg"
        ];
      };
    };

    settings = {
      direction = "float";
    };
  };

  keymaps = lib.mkIf config.plugins.toggleterm.enable [
    # TODO: remap
    # {
    #   mode = "n";
    #   key = "<leader>uT";
    #   action = "<cmd>ToggleTerm<CR>";
    #   options = {
    #     desc = "Open Terminal";
    #   };
    # }
    (lib.mkIf
      (
        !config.plugins.snacks.enable
        || (config.plugins.snacks.enable && !config.plugins.snacks.settings.lazygit.enabled)
      )
      {
        mode = "n";
        key = "<leader>gg";
        action.__raw = ''
          function()
            local toggleterm = require('toggleterm.terminal')

            toggleterm.Terminal:new({cmd = 'lazygit',hidden = true}):toggle()
          end
        '';
        options = {
          desc = "Open Lazygit";
          silent = true;
        };
      }
    )
    (lib.mkIf
      (
        !config.plugins.snacks.enable
        || (config.plugins.snacks.enable && !config.plugins.snacks.settings.lazygit.enabled)
      )
      {
        mode = "n";
        key = "<leader>gg";
        action.__raw = ''
          function()
            local toggleterm = require('toggleterm.terminal')

            toggleterm.Terminal:new({cmd = 'lazygit',hidden = true}):toggle()
          end
        '';
        options = {
          desc = "Open Lazygit";
          silent = true;
        };
      }
    )
  ];
}
