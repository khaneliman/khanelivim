{ config, lib, ... }:
{
  plugins.mini-operators = lib.mkIf (lib.elem "mini-operators" config.khanelivim.text.operators) {
    enable = true;
    settings = {
      # Exchange text regions
      exchange = {
        prefix = "gx";
      };

      # Multiply (duplicate) text
      multiply = {
        prefix = "gm";
      };

      # Replace text with register
      replace = {
        prefix = "gr";
      };

      # Sort text
      sort = {
        prefix = "gs";
      };
    };
  };

  plugins.which-key.settings.spec = lib.mkIf config.plugins.mini-operators.enable [
    {
      __unkeyed-1 = "gx";
      group = "Exchange";
      icon = "󰁍";
    }
    {
      __unkeyed-1 = "gm";
      group = "Multiply";
      icon = "";
    }
    {
      __unkeyed-1 = "gr";
      group = "Replace";
      icon = "";
    }
    {
      __unkeyed-1 = "gs";
      group = "Sort";
      icon = "󰒺";
    }
  ];

  keymaps = lib.mkIf config.plugins.mini-operators.enable [
    {
      mode = "n";
      key = "<leader>tx";
      action = "gxip";
      options = {
        desc = "Exchange paragraph";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tm";
      action.__raw = ''
        function()
          local count = vim.v.count1
          vim.cmd('normal! gm' .. count .. 'ip')
        end
      '';
      options = {
        desc = "Multiply paragraph";
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = "grip";
      options = {
        desc = "Replace paragraph with register";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "gsip";
      options = {
        desc = "Sort paragraph";
        remap = true;
      };
    }
  ];
}
