{ config, lib, ... }:
{
  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "files" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>lua MiniFiles.open()<CR>";
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
