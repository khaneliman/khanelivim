{
  lib,
  config,
  ...
}:
{
  keymaps = lib.mkIf config.plugins.fzf-lua.enable [
    {
      mode = "n";
      key = "<leader>gB";
      action = ''<cmd>FzfLua git_branches<CR>'';
      options = {
        desc = "Find git branches";
      };
    }
    {
      mode = "n";
      key = "<leader>gC";
      action = ''<cmd>FzfLua git_commits<CR>'';
      options = {
        desc = "Find git commits";
      };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = ''<cmd>FzfLua git_status<CR>'';
      options = {
        desc = "Find git status";
      };
    }
    {
      mode = "n";
      key = "<leader>gS";
      action = ''<cmd>FzfLua git_stash<CR>'';
      options = {
        desc = "Find git stashes";
      };
    }
  ];
}
