{ config, lib, ... }:
{
  plugins = {
    neoconf = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };

    which-key.settings.spec = lib.optionals config.plugins.neoconf.enable [
      {
        __unkeyed-1 = "<leader>C";
        mode = "n";
        icon = "";
        group = "Neoconf";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.neoconf.enable [
    {
      mode = "n";
      key = "<leader>Cc";
      action = "<cmd>Neoconf<cr>";
      options = {
        desc = "Select Config";
      };
    }
    {
      mode = "n";
      key = "<leader>Cl";
      action = "<cmd>Neoconf local<cr>";
      options = {
        desc = "Configure Local Settings";
      };
    }
    {
      mode = "n";
      key = "<leader>Cg";
      action = "<cmd>Neoconf global<cr>";
      options = {
        desc = "Configure Global Settings";
      };
    }
    {
      mode = "n";
      key = "<leader>Cs";
      action = "<cmd>Neoconf show<cr>";
      options = {
        desc = "Show Configuration";
      };
    }
    {
      mode = "n";
      key = "<leader>CL";
      action = "<cmd>Neoconf lsp<cr>";
      options = {
        desc = "Show LSP Configuration";
      };
    }
  ];
}
