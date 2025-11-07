{ config, lib, ... }:
{
  plugins.mini-animate = lib.mkIf (config.khanelivim.ui.animations == "mini-animate") {
    enable = true;
    settings = {
      cursor = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
      };
      scroll = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
      resize = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
      };
      open = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
      close = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
    };
  };

  plugins.which-key.settings.spec = lib.mkIf config.plugins.mini-animate.enable [
    {
      __unkeyed-1 = "<leader>ua";
      group = "Animations";
      icon = "󰚾";
    }
    {
      __unkeyed-1 = "<leader>uat";
      desc = "Toggle all animations";
    }
  ];

  keymaps = lib.mkIf config.plugins.mini-animate.enable [
    {
      mode = "n";
      key = "<leader>uat";
      action.__raw = ''
        function()
          local animate = require('mini.animate')
          local current = animate.config

          -- Toggle all animations
          local new_state = not current.cursor.enable

          animate.config.cursor.enable = new_state
          animate.config.scroll.enable = new_state
          animate.config.resize.enable = new_state
          animate.config.open.enable = new_state
          animate.config.close.enable = new_state

          vim.notify(
            "Animations " .. (new_state and "enabled" or "disabled"),
            vim.log.levels.INFO
          )
        end
      '';
      options = {
        desc = "Toggle all animations";
      };
    }
    {
      mode = "n";
      key = "<leader>uac";
      action.__raw = ''
        function()
          local animate = require('mini.animate')
          animate.config.cursor.enable = not animate.config.cursor.enable
          vim.notify(
            "Cursor animation " .. (animate.config.cursor.enable and "enabled" or "disabled"),
            vim.log.levels.INFO
          )
        end
      '';
      options = {
        desc = "Toggle cursor animation";
      };
    }
    {
      mode = "n";
      key = "<leader>uas";
      action.__raw = ''
        function()
          local animate = require('mini.animate')
          animate.config.scroll.enable = not animate.config.scroll.enable
          vim.notify(
            "Scroll animation " .. (animate.config.scroll.enable and "enabled" or "disabled"),
            vim.log.levels.INFO
          )
        end
      '';
      options = {
        desc = "Toggle scroll animation";
      };
    }
  ];
}
