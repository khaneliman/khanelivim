{ config, lib, ... }:
{
  keymaps = lib.mkIf (config.khanelivim.editor.fileManager == "mini-files") [
    {
      mode = "n";
      key = "<leader>E";
      action.__raw = "MiniFiles.open()";
      options = {
        desc = "Mini Files";
      };
    }
  ];

  plugins = lib.mkIf (config.khanelivim.editor.fileManager == "mini-files") {
    mini = {
      enable = true;

      modules = {
        files = { };
      };
    };
  };
}
