{ config, lib, ... }:
{
  # TODO:https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file#integrating-with-neo-tree
  plugins.neo-tree = {
    # neo-tree.nvim documentation
    # See: https://github.com/nvim-neo-tree/neo-tree.nvim
    enable = config.khanelivim.editor.fileManager == "neo-tree";

    lazyLoad.settings.cmd = [ "Neotree" ];

    settings = {
      close_if_last_window = true;

      filesystem = {
        filtered_items = {
          hide_dotfiles = false;
          hide_hidden = false;

          never_show_by_pattern = [
            ".direnv"
            ".git"
          ];

          visible = true;
        };

        follow_current_file = {
          enabled = true;
          leave_dirs_open = true;
        };

        use_libuv_file_watcher.__raw = ''vim.fn.has "win32" ~= 1'';
      };

      window = {
        width = 40;
        auto_expand_width = false;
      };
    };
  };

  keymaps = lib.mkIf config.plugins.neo-tree.enable [
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Neotree action=focus reveal toggle<CR>";
      options = {
        desc = "Explorer toggle";
      };
    }
  ];

}
