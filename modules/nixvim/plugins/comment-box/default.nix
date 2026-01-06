{ lib, config, ... }:
{
  plugins = {
    comment-box = {
      enable = lib.elem "comment-box" config.khanelivim.text.comments;

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
        __unkeyed-1 = "<leader>c";
        group = "Code & Comments";
        icon = " ";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.comment-box.enable [
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>CBd<cr>";
      options = {
        desc = "Delete a box";
      };
    }
    {
      mode = "n";
      key = "<leader>cb";
      action = "<cmd>CBccbox<cr>";
      options = {
        desc = "Box Title";
      };
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>CBllline<cr>";
      options = {
        desc = "Titled Line";
      };
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>CBline<cr>";
      options = {
        desc = "Simple Line";
      };
    }
  ];
}
