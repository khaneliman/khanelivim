{ config, lib, ... }:
{
  plugins.mini-move = lib.mkIf (config.khanelivim.editor.movement == "mini-move") {
    enable = true;
    settings = {
      mappings = {
        # Move visual selection
        left = "<M-h>";
        right = "<M-l>";
        down = "<M-j>";
        up = "<M-k>";

        # Move current line in Normal mode
        line_left = "<M-h>";
        line_right = "<M-l>";
        line_down = "<M-j>";
        line_up = "<M-k>";
      };
    };
  };
}
