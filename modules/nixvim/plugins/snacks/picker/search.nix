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
          key = "<leader><space>";
          action = "<cmd>lua Snacks.picker.smart()<cr>";
          options = {
            desc = "Smart Find Files";
          };
        }
        {
          mode = "n";
          key = "<leader>:";
          action = "<cmd>lua Snacks.picker.command_history()<cr>";
          options = {
            desc = "Command History";
          };
        }
        {
          mode = "n";
          key = "<leader>fb";
          action = "<cmd>lua Snacks.picker.buffers()<cr>";
          options = {
            desc = "Find buffers";
          };
        }
        {
          mode = "n";
          key = "<leader>fe";
          action = "<cmd>lua Snacks.explorer()<cr>";
          options = {
            desc = "File Explorer";
          };
        }
        {
          mode = "n";
          key = "<leader>ff";
          action = "<cmd>lua Snacks.picker.files()<cr>";
          options = {
            desc = "Find files";
          };
        }
        {
          mode = "n";
          key = "<leader>fFA";
          action = "<cmd>lua Snacks.picker.files({hidden = true, ignored = true})<cr>";
          options = {
            desc = "Find files (All files)";
          };
        }
        {
          mode = "n";
          key = "<leader>fo";
          action = "<cmd>lua Snacks.picker.recent()<cr>";
          options = {
            desc = "Find old files";
          };
        }
        {
          mode = "n";
          key = "<leader>fO";
          action = "<cmd>lua Snacks.picker.smart()<cr>";
          options = {
            desc = "Find Smart (Frecency)";
          };
        }
        {
          mode = "n";
          key = "<leader>fp";
          action = "<cmd>lua Snacks.picker.projects()<cr>";
          options = {
            desc = "Find projects";
          };
        }
        {
          mode = "n";
          key = "<leader>fq";
          action = "<cmd>lua Snacks.picker.qflist()<cr>";
          options = {
            desc = "Find quickfix";
          };
        }
        {
          mode = "n";
          key = "<leader>fw";
          action = "<cmd>lua Snacks.picker.grep()<cr>";
          options = {
            desc = "Live grep";
          };
        }
        {
          mode = "n";
          key = "<leader>fW";
          action = "<cmd>lua Snacks.picker.grep({hidden = true, ignored = true})<cr>";
          options = {
            desc = "Live grep (All files)";
          };
        }
        {
          mode = "n";
          key = "<leader>f/";
          action = "<cmd>lua Snacks.picker.lines()<cr>";
          options = {
            desc = "Fuzzy find in current buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>f?";
          action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
          options = {
            desc = "Fuzzy find in open buffers";
          };
        }
        {
          mode = "n";
          key = "<leader>f<CR>";
          action = "<cmd>lua Snacks.picker.resume()<cr>";
          options = {
            desc = "Resume find";
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>sw";
          action = "<cmd>lua Snacks.picker.grep_word()<cr>";
          options = {
            desc = "Search Word (visual or cursor)";
          };
        }
      ];
}
