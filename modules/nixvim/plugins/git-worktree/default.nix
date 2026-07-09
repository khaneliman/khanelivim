{
  config,
  lib,
  ...
}:
{
  # git-worktree.nvim documentation
  # See: https://github.com/ThePrimeagen/git-worktree.nvim
  plugins.git-worktree = {
    enable = lib.elem "git-worktree" config.khanelivim.git.integrations;

    settings = {
      change_directory_command = "cd";
      update_on_change = true;
      update_on_change_command = "e .";
    };
  };

  extraConfigLua = lib.mkIf config.plugins.git-worktree.enable ''
    local Hooks = require("git-worktree.hooks")
    local git_worktree_config = require('git-worktree.config')
    local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

    Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
    	vim.notify("Moved from " .. prev_path .. " to " .. path)
    	update_on_switch(path, prev_path)
    end)

    Hooks.register(Hooks.type.DELETE, function()
    	vim.cmd(git_worktree_config.update_on_change_command)
    end)
  '';
}
