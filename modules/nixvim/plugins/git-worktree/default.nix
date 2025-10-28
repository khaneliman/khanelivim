{
  config,
  lib,
  pkgs,
  ...
}:
let
  # cfg = config.plugins.git-worktree;

  worktreeEnabled = lib.elem "git-worktree" config.khanelivim.git.integrations;
  worktreeTelescopeEnabled = worktreeEnabled && config.plugins.telescope.enable;
in
{
  extraConfigLua = lib.mkIf (lib.elem "git-worktree" config.khanelivim.git.integrations) ''
    local Hooks = require("git-worktree.hooks")
    local config = require('git-worktree.config')
    local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

    Hooks.register(Hooks.type.SWITCH, function (path, prev_path)
    	vim.notify("Moved from " .. prev_path .. " to " .. path)
    	update_on_switch(path, prev_path)
    end)

    Hooks.register(Hooks.type.DELETE, function ()
    	vim.cmd(config.update_on_change_command)
    end)
  '';

  extraPlugins = lib.mkIf (lib.elem "git-worktree" config.khanelivim.git.integrations) (
    with pkgs.vimPlugins; [ git-worktree-nvim ]
  );

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
      action = "<cmd>Telescope git_worktree git_worktree<CR>";
      options = {
        desc = "Switch / Delete worktree";
        silent = true;
      };
    }
  ];
}
