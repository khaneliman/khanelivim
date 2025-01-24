{ config, lib, ... }:
let
  cfg = config.plugins.git-worktree;
in
{
  plugins = {
    git-worktree = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;

      # FIXME: telescope extension loading issue
      # lazyLoad.settings.cmd = [
      #   "Telescope git_worktree"
      # ];
    };

    which-key.settings.spec = lib.optionals (cfg.enableTelescope && cfg.enable) [
      {
        __unkeyed-1 = "<leader>gW";
        group = "Worktree";
        icon = "󰙅 ";
      }
    ];
  };

  keymaps = lib.mkIf cfg.enableTelescope [
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope git_worktree<CR>";
      options = {
        desc = "Git Worktree";
      };
    }
    {
      mode = "n";
      key = "<leader>gWc";
      action = "<cmd>Telescope git_worktree create_git_worktree<CR>";
      options = {
        desc = "Create worktree";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gWs";
      action = "<cmd>Telescope git_worktree git_worktrees<CR>";
      options = {
        desc = "Switch / Delete worktree";
        silent = true;
      };
    }
  ];
}
