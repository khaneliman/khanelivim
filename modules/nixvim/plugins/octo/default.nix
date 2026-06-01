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

  keymaps = lib.mkIf config.plugins.octo.enable (
    [
      {
        mode = "n";
        key = "<leader>gvo";
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
      {
        mode = "n";
        key = "<leader>gvc";
        action = "<cmd>Octo pr checkout<CR>";
        options = {
          desc = "Checkout PR";
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
    # When snacks-gh is absent, octo provides the PR/issue browse entry points.
    ++ lib.optionals (!hasSnacksGh) [
      {
        mode = "n";
        key = "<leader>gvp";
        action = "<cmd>Octo pr list<CR>";
        options = {
          desc = "Pull Requests";
        };
      }
      {
        mode = "n";
        key = "<leader>gvi";
        action = "<cmd>Octo issue list<CR>";
        options = {
          desc = "Issues";
        };
      }
    ]
  );
}
