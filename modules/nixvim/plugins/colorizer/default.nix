{ config, lib, ... }:
{
  plugins = {
    colorizer = {
      enable = true;

      lazyLoad.settings.cmd = "ColorizerToggle";
    };
  };

  keymaps = lib.mkIf config.plugins.colorizer.enable [
    {
      mode = "n";
      key = "<leader>uac";
      action.__raw = ''
        function ()
         vim.g.colorizing_enabled = not vim.g.colorizing_enabled
         vim.cmd('ColorizerToggle')
         vim.notify(string.format("Colorizing %s", bool2str(vim.g.colorizing_enabled), "info"))
        end
      '';
      options = {
        desc = "Colorizing toggle";
        silent = true;
      };
    }
  ];
}
