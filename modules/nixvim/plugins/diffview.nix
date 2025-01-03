{ config, lib, ... }:
{
  plugins = {
    diffview = {
      enable = true;
    };
  };

  keymaps = lib.mkIf config.plugins.diffview.enable [
    {
      mode = "n";
      key = "<leader>gd";
      action.__raw = ''
        function()
          vim.g.diffview_enabled = not vim.g.diffview_enabled
          if vim.g.diffview_enabled then
            vim.cmd('DiffviewClose')
          else
            vim.cmd('DiffviewOpen')
          end
        end
      '';
      options = {
        desc = "Git Diff toggle";
        silent = true;
      };
    }
  ];
}
