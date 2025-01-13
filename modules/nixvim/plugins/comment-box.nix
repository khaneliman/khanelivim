{ lib, config, ... }:
{
  plugins = {
    comment-box = {
      enable = true;

      lazyLoad = {
        settings = {
          cmd = [
            "CBd"
            "CBccbox"
            "CBllline"
            "CBline"
          ];
        };
      };

      settings = {
        # TODO: customize
        #   borders = {
        #     bottom_left = "X";
        #     bottom_right = "X";
        #     top_left = "X";
        #     top_right = "X";
        #   };
        #   box_width = 120;
        #   comment_style = "block";
        #   doc_width = 100;
        #   inner_blank_lines = true;
        #   line_width = 40;
        #   lines = {
        #     line = "*";
        #   };
        #   outer_blank_lines_below = true;
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.comment-box.enable [
      {
        __unkeyed-1 = "<leader>C";
        group = "Comment-box";
        icon = " ";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.comment-box.enable [
    {
      mode = "n";
      key = "<leader>Cd";
      action = "<cmd>CBd<cr>";
      options = {
        desc = "Delete a box";
      };
    }
    {
      mode = "n";
      key = "<leader>Cb";
      action = "<cmd>CBccbox<cr>";
      options = {
        desc = "Box Title";
      };
    }
    {
      mode = "n";
      key = "<leader>Ct";
      action = "<cmd>CBllline<cr>";
      options = {
        desc = "Titled Line";
      };
    }
    {
      mode = "n";
      key = "<leader>Cl";
      action = "<cmd>CBline<cr>";
      options = {
        desc = "Simple Line";
      };
    }
  ];
}
