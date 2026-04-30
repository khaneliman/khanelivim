{ config, lib, ... }:
{
  plugins.hunk = {
    enable =
      lib.elem "hunk" config.khanelivim.git.integrations || config.khanelivim.git.diffViewer == "hunk";

    lazyLoad.settings.cmd = "DiffEditor";

    settings = {
      keys = {
        global = {
          accept = [
            "<CR>"
            "<leader><CR>"
          ];
          focus_tree = [ "<leader>e" ];
          quit = [
            "q"
            "<Esc>"
          ];
        };
      };
      ui = {
        tree = {
          mode = "flat";
          width = 40;
        };
        layout = "horizontal";
        confirm_before_quit = true;
      };
      icons = {
        enable_file_icons =
          (config.plugins.web-devicons.enable or false) || config.plugins.mini-icons.enable;
      };
    };
  };
}
