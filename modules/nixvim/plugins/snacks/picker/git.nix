{
  config,
  lib,
  self,
  system,
  ...
}:
{
  extraPlugins = lib.mkIf (
    config.plugins.snacks.enable
    && lib.hasAttr "picker" config.plugins.snacks.settings
    && lib.elem "git-worktree" config.khanelivim.git.integrations
  ) [ self.packages.${system}.snacks-git-worktree ];

  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      (
        [
          {
            mode = "n";
            key = "<leader>gff";
            action = "<cmd>lua Snacks.picker.git_files()<cr>";
            options = {
              desc = "Git Files";
            };
          }
          {
            mode = "n";
            key = "<leader>gfb";
            action = "<cmd>lua Snacks.picker.git_branches()<cr>";
            options = {
              desc = "Git Branches";
            };
          }
          {
            mode = "n";
            key = "<leader>gfc";
            action = "<cmd>lua Snacks.picker.git_log()<cr>";
            options = {
              desc = "Git Commits";
            };
          }
          {
            mode = "n";
            key = "<leader>gfs";
            action = "<cmd>lua Snacks.picker.git_status()<cr>";
            options = {
              desc = "Git Status";
            };
          }
          {
            mode = "n";
            key = "<leader>gfh";
            action = "<cmd>lua Snacks.picker.git_stash()<cr>";
            options = {
              desc = "Git Stashes";
            };
          }
          {
            mode = "n";
            key = "<leader>gfL";
            action = "<cmd>lua Snacks.picker.git_log_line()<cr>";
            options = {
              desc = "Git Log Line";
            };
          }
          {
            mode = "n";
            key = "<leader>gfd";
            action = "<cmd>lua Snacks.picker.git_diff()<cr>";
            options = {
              desc = "Git Diff (Hunks)";
            };
          }
          {
            mode = "n";
            key = "<leader>gfa";
            action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
            options = {
              desc = "Git Log File";
            };
          }
        ]
        ++ lib.optionals (lib.elem "git-worktree" config.khanelivim.git.integrations) [
          {
            mode = "n";
            key = "<leader>gfw";
            action.__raw = ''
              function()
                require("khanelivim.snacks_git_worktree").pick_worktrees()
              end
            '';
            options = {
              desc = "Git Worktrees";
            };
          }
          {
            mode = "n";
            key = "<leader>gfW";
            action.__raw = ''
              function()
                require("khanelivim.snacks_git_worktree").create_worktree()
              end
            '';
            options = {
              desc = "Git Worktree Create";
            };
          }
          {
            mode = "n";
            key = "<leader>gfD";
            action.__raw = ''
              function()
                require("khanelivim.snacks_git_worktree").delete_worktree()
              end
            '';
            options = {
              desc = "Git Worktree Delete";
            };
          }
        ]
      );
}
