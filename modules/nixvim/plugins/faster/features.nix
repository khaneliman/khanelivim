{
  config,
  ...
}:
{
  config.plugins.faster.settings.features = {
    noice = {
      on = config.plugins.noice.enable;
      defer = false;
      enable.__raw = ''
        function()
          if pcall(require, "noice") then
            require("noice").enable()
          end
        end
      '';
      disable.__raw = ''
        function()
          if pcall(require, "noice") then
            require("noice").disable()
          end
        end
      '';
      commands.__raw = ''
        function()
          vim.api.nvim_create_user_command("FasterEnableNoice", function()
            if pcall(require, "noice") then
              require("noice").enable()
            end
          end, {})
          vim.api.nvim_create_user_command("FasterDisableNoice", function()
            if pcall(require, "noice") then
              require("noice").disable()
            end
          end, {})
        end
      '';
    };

    gitsigns = {
      on = config.plugins.gitsigns.enable;
      defer = false;
      enable.__raw = ''
        function()
          if pcall(require, "gitsigns") then
            require("gitsigns").toggle_signs(true)
            require("gitsigns").toggle_current_line_blame(true)
          end
        end
      '';
      disable.__raw = ''
        function()
          if pcall(require, "gitsigns") then
            require("gitsigns").toggle_signs(false)
            require("gitsigns").toggle_linehl(false)
            require("gitsigns").toggle_word_diff(false)
            require("gitsigns").toggle_current_line_blame(false)
          end
        end
      '';
      commands.__raw = ''
        function()
          vim.api.nvim_create_user_command("FasterEnableGitsigns", function()
            if pcall(require, "gitsigns") then
              require("gitsigns").toggle_signs(true)
              require("gitsigns").toggle_current_line_blame(true)
            end
          end, {})
          vim.api.nvim_create_user_command("FasterDisableGitsigns", function()
            if pcall(require, "gitsigns") then
              require("gitsigns").toggle_signs(false)
              require("gitsigns").toggle_linehl(false)
              require("gitsigns").toggle_word_diff(false)
              require("gitsigns").toggle_current_line_blame(false)
            end
          end, {})
        end
      '';
    };

    bufferline = {
      on = config.plugins.bufferline.enable;
      defer = false;
      enable.__raw = ''
        function()
          if pcall(require, "bufferline") then
            vim.opt.showtabline = 2
          end
        end
      '';
      disable.__raw = ''
        function()
          vim.opt.showtabline = 0
        end
      '';
      commands.__raw = ''
        function()
          vim.api.nvim_create_user_command("FasterEnableBufferline", function()
            if pcall(require, "bufferline") then
              vim.opt.showtabline = 2
            end
          end, {})
          vim.api.nvim_create_user_command("FasterDisableBufferline", function()
            vim.opt.showtabline = 0
          end, {})
        end
      '';
    };

    blink_indent = {
      on = config.plugins.blink-indent.enable;
      defer = false;
      enable.__raw = ''
        function()
          vim.b.indent_guide = true
        end
      '';
      disable.__raw = ''
        function()
          vim.b.indent_guide = false
        end
      '';
      commands.__raw = ''
        function()
          vim.api.nvim_create_user_command("FasterEnableBlinkIndent", function()
            vim.b.indent_guide = true
          end, {})
          vim.api.nvim_create_user_command("FasterDisableBlinkIndent", function()
            vim.b.indent_guide = false
          end, {})
        end
      '';
    };

    mini_indentscope = {
      on = config.plugins.mini-indentscope.enable;
      defer = false;
      enable.__raw = ''
        function()
          if pcall(require, "mini.indentscope") then
            vim.g.miniindentscope_disable = false
          end
        end
      '';
      disable.__raw = ''
        function()
          vim.g.miniindentscope_disable = true
        end
      '';
      commands.__raw = ''
        function()
          vim.api.nvim_create_user_command("FasterEnableMiniIndentscope", function()
            vim.g.miniindentscope_disable = false
          end, {})
          vim.api.nvim_create_user_command("FasterDisableMiniIndentscope", function()
            vim.g.miniindentscope_disable = true
          end, {})
        end
      '';
    };

    snacks = {
      on = config.plugins.snacks.enable;
      defer = false;
      enable.__raw = ''
        function()
          if pcall(require, "snacks") then
            local snacks = require("snacks")
            if snacks.scroll then snacks.scroll.enable() end
            if snacks.indent then snacks.indent.enable() end
          end
        end
      '';
      disable.__raw = ''
        function()
          if pcall(require, "snacks") then
            local snacks = require("snacks")
            if snacks.scroll then snacks.scroll.disable() end
            if snacks.indent then snacks.indent.disable() end
          end
        end
      '';
      commands.__raw = ''
        function()
          vim.api.nvim_create_user_command("FasterEnableSnacks", function()
            if pcall(require, "snacks") then
              local snacks = require("snacks")
              if snacks.scroll then snacks.scroll.enable() end
              if snacks.indent then snacks.indent.enable() end
            end
          end, {})
          vim.api.nvim_create_user_command("FasterDisableSnacks", function()
            if pcall(require, "snacks") then
              local snacks = require("snacks")
              if snacks.scroll then snacks.scroll.disable() end
              if snacks.indent then snacks.indent.disable() end
            end
          end, {})
        end
      '';
    };
  };
}
