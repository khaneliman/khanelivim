{ config, lib, ... }:
{
  plugins.markview = {
    enable = true;

    lazyLoad.settings.ft = "markdown";

    settings = {
      preview = {
        buf_ignore = [ ];

        modes = [
          "n"
          "x"
          "i"
          "r"
        ];

        hybrid_modes = [
          "i"
          "r"
        ];
      };
    };
  };

  keymaps = lib.mkIf config.plugins.markview.enable [
    {
      mode = "n";
      key = "<leader>um";
      action = "<cmd>Markview toggle<CR>";
      options = {
        desc = "Toggle Markdown Preview";
      };
    }
  ];
}
