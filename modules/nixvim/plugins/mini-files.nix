{ config, lib, ... }:
{
  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "files" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>E";
      action.__raw = "MiniFiles.open()";
      options = {
        desc = "Mini Files";
      };
    }
  ];

  plugins = {
    mini = {
      enable = true;

      modules = {
        # files = { };
      };
    };
  };
}
