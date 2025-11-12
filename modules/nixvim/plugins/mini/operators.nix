{ config, lib, ... }:
{
  plugins.mini-operators = lib.mkIf (lib.elem "mini-operators" config.khanelivim.text.operators) {
    enable = true;
    settings = {
      # Exchange text regions
      # - Use `<C-c>` to stop exchanging after the first step.
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
      icon = "󰁍 ";
    }
    {
      __unkeyed-1 = "gm";
      group = "Multiply";
      icon = "󰎂 ";
    }
    {
      __unkeyed-1 = "gr";
      group = "Replace";
      icon = " ";
    }
    {
      __unkeyed-1 = "gs";
      group = "Sort";
      icon = "󰒺 ";
    }
  ];
}
