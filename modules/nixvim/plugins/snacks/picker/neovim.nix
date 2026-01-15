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
          key = "<leader>fa";
          action = "<cmd>lua Snacks.picker.autocmds()<cr>";
          options = {
            desc = "Find autocmds";
          };
        }
        {
          mode = "n";
          key = "<leader>fc";
          action = "<cmd>lua Snacks.picker.commands()<cr>";
          options = {
            desc = "Find commands";
          };
        }
        {
          mode = "n";
          key = "<leader>fC";
          action.__raw = ''
            function()
              require("snacks.picker").files {
                prompt_title = "Config Files",
                cwd = vim.fn.stdpath("config"),
              }
            end
          '';
          options = {
            desc = "Find config files";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>fh";
          action = "<cmd>lua Snacks.picker.help()<cr>";
          options = {
            desc = "Find help tags";
          };
        }
        {
          mode = "n";
          key = "<leader>fk";
          action = "<cmd>lua Snacks.picker.keymaps()<cr>";
          options = {
            desc = "Find keymaps";
          };
        }
        {
          mode = "n";
          key = "<leader>fL";
          action.__raw = ''
            function()
              Snacks.picker.files({
                dirs = { vim.fn.stdpath("state") },
                ft = "log",
                hidden = true,
                ignored = true,
                title = "Neovim Logs",
              })
            end
          '';
          options = {
            desc = "Find Neovim Logs";
          };
        }
        {
          mode = "n";
          key = "<leader>fm";
          action = "<cmd>lua Snacks.picker.man()<cr>";
          options = {
            desc = "Find man pages";
          };
        }
        {
          mode = "n";
          key = "<leader>fr";
          action = "<cmd>lua Snacks.picker.registers()<cr>";
          options = {
            desc = "Find registers";
          };
        }
        {
          mode = "n";
          key = "<leader>fu";
          action = "<cmd>lua Snacks.picker.undo()<cr>";
          options = {
            desc = "Undo History";
          };
        }
        {
          mode = "n";
          key = "<leader>f'";
          action = "<cmd>lua Snacks.picker.marks()<cr>";
          options = {
            desc = "Find marks";
          };
        }
        {
          mode = "n";
          key = "<leader>fj";
          action = "<cmd>lua Snacks.picker.jumps()<cr>";
          options = {
            desc = "Find jumps";
          };
        }
        {
          mode = "n";
          key = "<leader>X";
          action = "<cmd>lua Snacks.profiler.toggle()<cr>";
          options = {
            desc = "Toggle Neovim profiler";
          };
        }
      ];
}
