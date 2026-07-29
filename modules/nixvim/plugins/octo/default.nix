{
  config,
  lib,
  pkgs,
  ...
}:
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

    package = pkgs.vimPlugins.octo-nvim.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          url = "https://github.com/pwntester/octo.nvim/commit/57068fcdc0e9156f739abcf7fe9f0c057b762b11.patch";
          hash = "sha256-65PkXtiIYpdSI+Qs/XEsWffCJeai7HNfH8Br+4JawoY=";
        })
      ];
    });

    settings = {
      enable_builtin = true;
      notifications.current_repo_only = true;
      picker = lib.mkIf (
        config.khanelivim.picker.tool != null
      ) pickerByTool.${config.khanelivim.picker.tool};
      poll = {
        enabled = false;
        interval = 30000;
      };
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
        action.__raw = ''
          function()
            ${lib.optionalString config.plugins.lz-n.enable ''require("lz.n").trigger_load("octo.nvim")''}
            require("octo.utils").create_base_search_command({ include_current_repo = true })
          end
        '';
        options = {
          desc = "Search";
        };
      }
      {
        mode = "n";
        key = "<leader>gva";
        action = "<cmd>Octo<CR>";
        options = {
          desc = "Actions";
        };
      }
      {
        mode = "n";
        key = "<leader>gvn";
        action = "<cmd>Octo notification list<CR>";
        options = {
          desc = "Notifications";
        };
      }
      {
        mode = "n";
        key = "<leader>gvw";
        action = "<cmd>Octo poll toggle<CR>";
        options = {
          desc = "Toggle polling";
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
