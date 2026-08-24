{
  config,
  lib,
  ...
}:
{
  plugins.tuis.enable = lib.mkDefault true;

  keymaps = lib.mkIf config.plugins.tuis.enable [
    {
      mode = "n";
      key = "<leader>uT";
      action.__raw = ''
        function()
          require('tuis').choose()
        end
      '';
      options = {
        desc = "Choose TUI";
      };
    }
  ];
}
