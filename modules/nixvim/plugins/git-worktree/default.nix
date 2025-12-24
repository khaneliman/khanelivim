{
  config,
  lib,
  pkgs,
  ...
}:
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
}
