{ config, lib, ... }:
{
  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "files" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>E";
      action = ":lua MiniFiles.open()<CR>";
      options = {
        desc = "Mini Files";
        silent = true;
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
