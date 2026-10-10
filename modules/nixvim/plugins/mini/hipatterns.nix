{ config, lib, ... }:
{
  plugins.mini-hipatterns = lib.mkIf (lib.elem "mini-hipatterns" config.khanelivim.text.patterns) {
    enable = true;
    settings = {
      highlighters = {
        hex_color.__raw = ''require("mini.hipatterns").gen_highlighter.hex_color()'';
      };
    };
  };
}
