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
        # jdtls can choke on background code-action probes when external
        # diagnostics include invalid ranges, so keep lightbulb manual for Java.
        ignore.clients = [ "jdtls" ];
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
