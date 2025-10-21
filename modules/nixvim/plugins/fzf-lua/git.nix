{
  lib,
  config,
  ...
}:
{
  keymaps = lib.mkIf (config.khanelivim.picker.engine == "fzf") [
    {
      mode = "n";
      key = "<leader>gfb";
      action = ''<cmd>FzfLua git_branches<CR>'';
      options = {
        desc = "Find git branches";
      };
    }
    {
      mode = "n";
      key = "<leader>gfc";
      action = ''<cmd>FzfLua git_commits<CR>'';
      options = {
        desc = "Find git commits";
      };
    }
    {
      mode = "n";
      key = "<leader>gfs";
      action = ''<cmd>FzfLua git_status<CR>'';
      options = {
        desc = "Find git status";
      };
    }
    {
      mode = "n";
      key = "<leader>gfh";
      action = ''<cmd>FzfLua git_stash<CR>'';
      options = {
        desc = "Find git stashes";
      };
    }
  ];
}
