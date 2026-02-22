{ config, lib, ... }:
{
  plugins = {
    diffview = {
      enable = config.khanelivim.git.diffViewer == "diffview";

      lazyLoad = {
        settings = {
          ft = "diff";
          cmd = "DiffviewOpen";
        };
      };

      settings = {
      };
    };
  };

  keymaps = lib.mkIf config.plugins.diffview.enable (
    [
      {
        mode = "n";
        key = "<leader>gdv";
        action.__raw = ''
          function()
            local has_view = false
            local ok, lib = pcall(require, "diffview.lib")
            if ok then
              has_view = lib.get_current_view() ~= nil
            end
            if has_view then
              vim.cmd('DiffviewClose')
            else
              vim.cmd('DiffviewOpen')
            end
          end
        '';
        options = {
          desc = "Diffview Toggle";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gdV";
        action.__raw = ''
          function()
            local has_view = false
            local ok, lib = pcall(require, "diffview.lib")
            if ok then
              has_view = lib.get_current_view() ~= nil
            end
            if has_view then
              vim.cmd('DiffviewClose')
            else
              vim.cmd('DiffviewOpen FETCH_HEAD')
            end
          end
        '';
        options = {
          desc = "Diffview Toggle HEAD";
          silent = true;
        };
      }
    ]
    ++ lib.optionals (config.khanelivim.git.diffViewer == "diffview") [
      # Primary diff shortcut when diffview is the chosen diff viewer
      {
        mode = "n";
        key = "<leader>gD";
        action.__raw = ''
          function()
            local has_view = false
            local ok, lib = pcall(require, "diffview.lib")
            if ok then
              has_view = lib.get_current_view() ~= nil
            end
            if has_view then
              vim.cmd('DiffviewClose')
            else
              vim.cmd('DiffviewOpen')
            end
          end
        '';
        options = {
          desc = "Toggle Diff (Primary)";
          silent = true;
        };
      }
    ]
  );
}
