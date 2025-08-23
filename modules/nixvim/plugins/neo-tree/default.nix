{ config, lib, ... }:
{
  keymaps = lib.mkIf (config.khanelivim.editor.fileManager == "neo-tree") [
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Neotree action=focus reveal toggle<CR>";
      options = {
        desc = "Explorer toggle";
      };
    }
  ];

  # TODO:https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file#integrating-with-neo-tree
  plugins.neo-tree = {
    enable = config.khanelivim.editor.fileManager == "neo-tree";

    closeIfLastWindow = true;

    filesystem = {
      filteredItems = {
        hideDotfiles = false;
        hideHidden = false;

        neverShowByPattern = [
          ".direnv"
          ".git"
        ];

        visible = true;
      };

      followCurrentFile = {
        enabled = true;
        leaveDirsOpen = true;
      };

      useLibuvFileWatcher.__raw = ''vim.fn.has "win32" ~= 1'';
    };

    window = {
      width = 40;
      autoExpandWidth = false;
    };
  };
}
