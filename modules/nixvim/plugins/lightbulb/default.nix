{
  plugins = {
    nvim-lightbulb = {
      # nvim-lightbulb documentation
      # See: https://github.com/kosayoda/nvim-lightbulb
      enable = true;

      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];

      settings = {
        autocmd = {
          enabled = true;
          updatetime = 200;
        };
        line = {
          enabled = true;
        };
        number = {
          enabled = true;
        };
        sign = {
          enabled = true;
          text = " 󰌶";
        };
        status_text = {
          enabled = true;
          text = " 󰌶 ";
        };
      };
    };
  };
}
