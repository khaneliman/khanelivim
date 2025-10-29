{ config, lib, ... }:
{
  plugins = lib.mkIf (lib.elem "mini-notify" config.khanelivim.ui.notifications) {
    mini = {
      enable = true;

      modules = {
        notify = {
          # Configuration for mini.notify
          # Uses vim.notify() interface
        };
      };
    };
  };
}
