{
  config,
  lib,
  pkgs,
  ...
}:
let
  # cfg = config.plugins.git-worktree;

  worktreeTelescopeEnabled =
    (builtins.elem pkgs.vimPlugins.git-worktree-nvim config.extraPlugins)
    && config.plugins.telescope.enable;
in
{
  extraPlugins = with pkgs.vimPlugins; [ git-worktree-nvim ];

  plugins = {
    # TODO: upstream nixpkg package change to use new fork
    # TODO: upstream module change to not call setup with new fork
    # git-worktree = {
    #   enable = true;
    #   enableTelescope = config.plugins.telescope.enable;
    #
    #   # FIXME: telescope extension loading issue
    #   # lazyLoad.settings.cmd = [
    #   #   "Telescope git_worktree"
    #   # ];
    # };

    telescope.enabledExtensions = lib.optionals worktreeTelescopeEnabled [ "git_worktree" ];

    which-key.settings.spec = lib.optionals worktreeTelescopeEnabled [
      {
        __unkeyed-1 = "<leader>gW";
        group = "Worktree";
        icon = "󰙅 ";
      }
    ];
  };

  keymaps = lib.mkIf worktreeTelescopeEnabled [
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
