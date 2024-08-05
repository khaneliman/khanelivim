_: {
  plugins.which-key = {
    enable = true;

    settings = {
      spec = [
        {
          __unkeyed = "<leader>b";
          group = "󰓩 Buffers";
        }
        {
          __unkeyed = "<leader>bs";
          group = "󰒺 Sort";
        }
        {
          __unkeyed = "<leader>d";
          group = "  Debug";
        }
        {
          __unkeyed = "<leader>g";
          group = "󰊢 Git";
        }
        {
          __unkeyed = "<leader>f";
          group = " Find";
        }
        {
          __unkeyed = "<leader>r";
          group = " Refactor";
        }
        {
          __unkeyed = "<leader>t";
          group = " Terminal";
        }
        {
          __unkeyed = "<leader>u";
          group = " UI/UX";
        }
      ];
    };

    keyLabels = {
      "<space>" = "SPACE";
      "<leader>" = "SPACE";
      "<cr>" = "RETURN";
      "<CR>" = "RETURN";
      "<tab>" = "TAB";
      "<TAB>" = "TAB";
      "<bs>" = "BACKSPACE";
      "<BS>" = "BACKSPACE";
    };

    window = {
      border = "single";
    };
  };
}
