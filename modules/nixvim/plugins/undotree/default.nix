{ config, lib, ... }:
{
  plugins = {
    undotree = {
      # undotree documentation
      # See: https://github.com/mbbill/undotree
      enable = true;
      # Put plugin in opt/ for lazy loading
      autoLoad = false;

      settings = {
        CursorLine = true;
        DiffAutoOpen = true;
        DiffCommand = "diff";
        DiffpanelHeight = 10;
        HelpLine = true;
        HighlightChangedText = true;
        HighlightChangedWithSign = true;
        HighlightSyntaxAdd = "DiffAdd";
        HighlightSyntaxChange = "DiffChange";
        HighlightSyntaxDel = "DiffDelete";
        RelativeTimestamp = true;
        SetFocusWhenToggle = true;
        ShortIndicators = false;
        TreeNodeShape = "*";
        TreeReturnShape = "\\";
        TreeSplitShape = "/";
        TreeVertShape = "|";
        WindowLayout = 2;
      };
    };
  };

  # Lazy load via lz-n
  plugins.lz-n.plugins = lib.mkIf config.plugins.undotree.enable [
    {
      __unkeyed-1 = "undotree";
      cmd = [
        "UndotreeToggle"
        "UndotreeShow"
        "UndotreeHide"
        "UndotreeFocus"
      ];
      keys = [
        {
          __unkeyed-1 = "<leader>ueu";
          __unkeyed-2 = "<cmd>UndotreeToggle<CR>";
          desc = "Undotree toggle";
        }
      ];
    }
  ];
}
