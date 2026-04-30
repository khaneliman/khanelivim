{ config, lib, ... }:
let
  hasSnacksGh = lib.elem "snacks-gh" config.khanelivim.git.integrations;

  pickerByTool = {
    fzf = "fzf-lua";
    snacks = "snacks";
  };
in
{
  plugins.octo = {
    enable = lib.elem "octo" config.khanelivim.git.integrations;

    lazyLoad.settings.cmd = "Octo";

    settings = {
      picker = lib.mkIf (
        config.khanelivim.picker.tool != null
      ) pickerByTool.${config.khanelivim.picker.tool};
      use_local_fs = true;
    };
  };

  plugins.which-key.settings.spec = lib.optionals config.plugins.octo.enable [
    {
      __unkeyed-1 = "<leader>gv";
      group = "GitHub Review";
      icon = "";
      mode = [
        "n"
      ];
    }
  ];

  keymaps = lib.mkIf config.plugins.octo.enable (
    [
      {
        mode = "n";
        key = "<leader>gvp";
        action = "<cmd>Octo pr<CR>";
        options = {
          desc = "Open PR";
        };
      }
      {
        mode = "n";
        key = "<leader>gvr";
        action = "<cmd>Octo review start<CR>";
        options = {
          desc = "Start Review";
        };
      }
      {
        mode = "n";
        key = "<leader>gvR";
        action = "<cmd>Octo review resume<CR>";
        options = {
          desc = "Resume Review";
        };
      }
    ]
    ++ lib.optionals (!hasSnacksGh) [
      {
        mode = "n";
        key = "<leader>gvP";
        action = "<cmd>Octo pr list<CR>";
        options = {
          desc = "List PRs";
        };
      }
      {
        mode = "n";
        key = "<leader>gvi";
        action = "<cmd>Octo issue list<CR>";
        options = {
          desc = "List Issues";
        };
      }
      {
        mode = "n";
        key = "<leader>gvs";
        action = "<cmd>Octo search<CR>";
        options = {
          desc = "Search";
        };
      }
      {
        mode = "n";
        key = "<leader>gva";
        action = "<cmd>Octo actions<CR>";
        options = {
          desc = "Actions";
        };
      }
    ]
  );
}
