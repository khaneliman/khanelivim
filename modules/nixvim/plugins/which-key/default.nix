{
  plugins.which-key = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffers";
        }
        {
          __unkeyed-1 = "<leader>bs";
          group = "󰒺 Sort";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>gf";
          group = "Git Find";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "Refactor";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "UI/UX";
        }
      ];

      replace = {
        # key = [
        #   [
        #     "<Space>"
        #     "SPC"
        #   ]
        # ];

        desc = [
          [
            "<space>"
            "SPACE"
          ]
          [
            "<leader>"
            "SPACE"
          ]
          [
            "<[cC][rR]>"
            "RETURN"
          ]
          [
            "<[tT][aA][bB]>"
            "TAB"
          ]
          [
            "<[bB][sS]>"
            "BACKSPACE"
          ]
        ];
      };
      win = {
        border = "single";
      };

      # preset = "helix";
    };
  };
}
