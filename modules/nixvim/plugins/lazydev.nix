{ config, lib, ... }:
{
  plugins = {
    lazydev = {
      enable = true;

      lazyLoad.settings.cmd = [
        "LazyDev"
      ];
    };

    which-key.settings.spec = lib.optionals config.plugins.persistence.enable [
      {
        __unkeyed-1 = "<leader>ll";
        group = "LazyDev";
        icon = "";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.lazydev.enable [
    {
      mode = "n";
      key = "<leader>lld";
      action = "<CMD>LazyDev debug<CR>";
      options.desc = "LazyDev debug";
    }
    {
      mode = "n";
      key = "<leader>lll";
      action = "<CMD>LazyDev lsp<CR>";
      options.desc = "LazyDev lsp";
    }
  ];
}
