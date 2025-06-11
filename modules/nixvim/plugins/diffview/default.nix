{ config, lib, ... }:
{
  plugins = {
    diffview = {
      enable = !config.plugins.unified.enable;

      # TODO: migrate to mkNeovimPlugin
      # lazyLoad = {
      #   settings = {
      #     ft = "diff";
      #     cmd = "DiffviewOpen";
      #   };
      # };
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
        desc = "Git Diff";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gD";
      action.__raw = ''
        function()
          vim.g.diffview_enabled = not vim.g.diffview_enabled
          if vim.g.diffview_enabled then
            vim.cmd('DiffviewClose')
          else
            vim.cmd('DiffviewOpen FETCH_HEAD')
          end
        end
      '';
      options = {
        desc = "Git Diff HEAD";
        silent = true;
      };
    }
  ];
}
