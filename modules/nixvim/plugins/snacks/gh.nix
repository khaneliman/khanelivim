{
  config,
  lib,
  ...
}:
let
  isEnabled = lib.elem "snacks-gh" config.khanelivim.git.integrations;
in
{
  dependencies.gh.enable = lib.mkDefault isEnabled;

  plugins = {
    snacks = {
      settings = {
        gh = {
          enabled = isEnabled;
          # Buffer keymaps for GitHub buffers
          keys = {
            select = {
              __raw = ''{ "<cr>", "gh_actions", desc = "Select Action" }'';
            };
            edit = {
              __raw = ''{ "i", "gh_edit", desc = "Edit" }'';
            };
            comment = {
              __raw = ''{ "a", "gh_comment", desc = "Add Comment" }'';
            };
            close = {
              __raw = ''{ "c", "gh_close", desc = "Close" }'';
            };
            reopen = {
              __raw = ''{ "o", "gh_reopen", desc = "Reopen" }'';
            };
          };
        };
      };
    };
  };

  keymaps = lib.mkIf isEnabled [
    {
      mode = "n";
      key = "<leader>gvi";
      action.__raw = "function() Snacks.picker.gh_issue() end";
      options = {
        desc = "Issues (open)";
      };
    }
    {
      mode = "n";
      key = "<leader>gvI";
      action.__raw = "function() Snacks.picker.gh_issue({ state = 'all' }) end";
      options = {
        desc = "Issues (all)";
      };
    }
    {
      mode = "n";
      key = "<leader>gvp";
      action.__raw = "function() Snacks.picker.gh_pr() end";
      options = {
        desc = "Pull Requests (open)";
      };
    }
    {
      mode = "n";
      key = "<leader>gvP";
      action.__raw = "function() Snacks.picker.gh_pr({ state = 'all' }) end";
      options = {
        desc = "Pull Requests (all)";
      };
    }
  ];
}
