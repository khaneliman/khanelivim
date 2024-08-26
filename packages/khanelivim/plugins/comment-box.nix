{
  plugins = {
    comment-box = {
      enable = true;

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
  };

  # TODO: add keybinds
  # keymaps = lib.mkIf config.plugins.nvim-colorizer.enable [
  #   {
  #     mode = "n";
  #     key = "<leader>uC";
  #     action.__raw = ''
  #       function ()
  #       end
  #     '';
  #     options = {
  #       desc = "Colorizing toggle";
  #       silent = true;
  #     };
  #   }
  # ];
}
