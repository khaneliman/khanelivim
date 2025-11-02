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
}
