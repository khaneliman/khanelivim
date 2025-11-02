{ config, lib, ... }:
{
  plugins.mini-trailspace = lib.mkIf (config.khanelivim.text.whitespace == "mini-trailspace") {
    enable = true;
  };

  keymaps = lib.mkIf config.plugins.mini-trailspace.enable [
    {
      mode = "n";
      key = "<leader>lw";
      action.__raw = "MiniTrailspace.trim";
      options = {
        desc = "Trim trailing whitespace";
      };
    }
    {
      mode = "n";
      key = "<leader>lwl";
      action.__raw = "MiniTrailspace.trim_last_lines";
      options = {
        desc = "Trim trailing empty lines";
      };
    }
  ];
}
