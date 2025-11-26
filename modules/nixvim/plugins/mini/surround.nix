{
  plugins = {
    mini-surround = {
      enable = true;

      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "gsa";
          mode = [
            "n"
            "v"
          ];
          desc = "Add surrounding";
        }
        {
          __unkeyed-1 = "gsd";
          desc = "Delete surrounding";
        }
        {
          __unkeyed-1 = "gsf";
          desc = "Find surrounding (right)";
        }
        {
          __unkeyed-1 = "gsF";
          desc = "Find surrounding (left)";
        }
        {
          __unkeyed-1 = "gsh";
          desc = "Highlight surrounding";
        }
        {
          __unkeyed-1 = "gsr";
          desc = "Replace surrounding";
        }
        {
          __unkeyed-1 = "gsn";
          desc = "Update n_lines";
        }
      ];

      settings = {
        mappings = {
          add = "gsa"; # -- Add surrounding in Normal and Visual modes
          delete = "gsd"; # -- Delete surrounding
          find = "gsf"; # -- Find surrounding (to the right)
          find_left = "gsF"; # -- Find surrounding (to the left)
          highlight = "gsh"; # -- Highlight surrounding
          replace = "gsr"; # -- Replace surrounding
          update_n_lines = "gsn"; # -- Update `n_lines`
        };
      };
    };
  };
}
