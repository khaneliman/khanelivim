{ config, lib, ... }:
{
  plugins = {
    neoconf = {
      enable = true;
    };

    which-key.settings.spec = lib.optionals config.plugins.neoconf.enable [
      {
        __unkeyed-1 = "<leader>N";
        mode = "n";
        icon = "";
        group = "Neoconf";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.neoconf.enable [
    {
      mode = "n";
      key = "<leader>Nc";
      action = "<cmd>Neoconf<cr>";
      options = {
        desc = "Select Config";
      };
    }
    {
      mode = "n";
      key = "<leader>Nl";
      action = "<cmd>Neoconf local<cr>";
      options = {
        desc = "Configure Local Settings";
      };
    }
    {
      mode = "n";
      key = "<leader>Ng";
      action = "<cmd>Neoconf global<cr>";
      options = {
        desc = "Configure Global Settings";
      };
    }
    {
      mode = "n";
      key = "<leader>Ns";
      action = "<cmd>Neoconf show<cr>";
      options = {
        desc = "Show Configuration";
      };
    }
    {
      mode = "n";
      key = "<leader>NL";
      action = "<cmd>Neoconf lsp<cr>";
      options = {
        desc = "Show LSP Configuration";
      };
    }
  ];
}
