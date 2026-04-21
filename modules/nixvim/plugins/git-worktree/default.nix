{
  config,
  lib,
  pkgs,
  ...
}:
{
  # git-worktree.nvim documentation
  # See: https://github.com/ThePrimeagen/git-worktree.nvim
  extraConfigLua = lib.mkIf (lib.elem "git-worktree" config.khanelivim.git.integrations) ''
    local git_worktree_cfg = vim.g.git_worktree
    if type(git_worktree_cfg) == "function" then
      git_worktree_cfg = git_worktree_cfg()
    end
    if type(git_worktree_cfg) ~= "table" then
      git_worktree_cfg = {}
    end
    vim.g.git_worktree = vim.tbl_extend("force", git_worktree_cfg, {
      update_on_change = true,
      update_on_change_command = "e .",
      change_directory_command = "cd",
    })

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
}
