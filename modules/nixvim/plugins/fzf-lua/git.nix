{
  lib,
  config,
  ...
}:
{
  keymaps = lib.mkIf (config.khanelivim.picker.tool == "fzf") [
    {
      mode = "n";
      key = "<leader>gfb";
      action = "<cmd>FzfLua git_branches<CR>";
      options = {
        desc = "Git Branches";
      };
    }
    {
      mode = "n";
      key = "<leader>gfc";
      action = "<cmd>FzfLua git_commits<CR>";
      options = {
        desc = "Git Commits";
      };
    }
    {
      mode = "n";
      key = "<leader>gfs";
      action = "<cmd>FzfLua git_status<CR>";
      options = {
        desc = "Git Status";
      };
    }
    {
      mode = "n";
      key = "<leader>gfh";
      action = "<cmd>FzfLua git_stash<CR>";
      options = {
        desc = "Git Stashes";
      };
    }
  ];
}
