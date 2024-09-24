{ config, lib, ... }:
{
  plugins = {
    git-conflict = {
      enable = true;

      settings = {
        disable_diagnostics = true;
        default_mappings = {
          ours = "co";
          theirs = "ct";
          none = "c0";
          both = "cb";
          next = "]x";
          prev = "[x";
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.git-conflict.enable [
      {
        __unkeyed = "<leader>gc";
        group = "Conflicts";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.git-conflict.enable [
    {
      mode = "n";
      key = "<leader>gc]";
      action = "<cmd>GitConflictNextConflict<CR>";
      options = {
        desc = "Next";
      };
    }
    {
      mode = "n";
      key = "<leader>gc[";
      action = "<cmd>GitConflictPrevConflict<CR>";
      options = {
        desc = "Prev";
      };
    }
    {
      mode = "n";
      key = "<leader>gcr";
      action = "<cmd>GitConflictRefresh<CR>";
      options = {
        desc = "Refresh";
      };
    }
    {
      mode = "n";
      key = "<leader>gcb";
      action = "<cmd>GitConflictChooseBase<CR>";
      options = {
        desc = "Choose Base";
      };
    }
    {
      mode = "n";
      key = "<leader>gcB";
      action = "<cmd>GitConflictChooseBoth<CR>";
      options = {
        desc = "Choose Both";
      };
    }
    {
      mode = "n";
      key = "<leader>gct";
      action = "<cmd>GitConflictChooseTheirs<CR>";
      options = {
        desc = "Choose Theirs";
      };
    }
    {
      mode = "n";
      key = "<leader>gco";
      action = "<cmd>GitConflictChooseOurs<CR>";
      options = {
        desc = "Choose Ours";
      };
    }
    {
      mode = "n";
      key = "<leader>gcn";
      action = "<cmd>GitConflictChooseNone<CR>";
      options = {
        desc = "Choose None";
      };
    }
    {
      mode = "n";
      key = "<leader>gcl";
      action = "<cmd>GitConflictListQf<CR>";
      options = {
        desc = "List";
      };
    }
  ];
}
