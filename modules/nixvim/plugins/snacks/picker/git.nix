{
  config,
  lib,
  ...
}:
{
  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      [
        {
          mode = "n";
          key = "<leader>fG";
          action = ''<cmd>lua Snacks.picker.git_files()<cr>'';
          options = {
            desc = "Find Git Files";
          };
        }
        {
          mode = "n";
          key = "<leader>gB";
          action = ''<cmd>lua Snacks.picker.git_branches()<cr>'';
          options = {
            desc = "Find git branches";
          };
        }
        {
          mode = "n";
          key = "<leader>gC";
          action = ''<cmd>lua Snacks.picker.git_log()<cr>'';
          options = {
            desc = "Find git commits";
          };
        }
        {
          mode = "n";
          key = "<leader>gs";
          action = ''<cmd>lua Snacks.picker.git_status()<cr>'';
          options = {
            desc = "Find git status";
          };
        }
        {
          mode = "n";
          key = "<leader>gS";
          action = ''<cmd>lua Snacks.picker.git_stash()<cr>'';
          options = {
            desc = "Find git stashes";
          };
        }
        {
          mode = "n";
          key = "<leader>gl";
          action = ''<cmd>lua Snacks.picker.git_log()<cr>'';
          options = {
            desc = "Git Log";
          };
        }
        {
          mode = "n";
          key = "<leader>gL";
          action = ''<cmd>lua Snacks.picker.git_log_line()<cr>'';
          options = {
            desc = "Git Log Line";
          };
        }
        {
          mode = "n";
          key = "<leader>gd";
          action = ''<cmd>lua Snacks.picker.git_diff()<cr>'';
          options = {
            desc = "Git Diff (Hunks)";
          };
        }
        {
          mode = "n";
          key = "<leader>gf";
          action = ''<cmd>lua Snacks.picker.git_log_file()<cr>'';
          options = {
            desc = "Git Log File";
          };
        }
      ];
}
