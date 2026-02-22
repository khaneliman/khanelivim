{ pkgs, ... }:
{
  plugins = {
    nvim-lightbulb = {
      # nvim-lightbulb documentation
      # See: https://github.com/kosayoda/nvim-lightbulb
      enable = true;
      package = pkgs.vimPlugins.nvim-lightbulb.overrideAttrs (_old: {
        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/kosayoda/nvim-lightbulb/pull/78.patch";
            hash = "sha256-Ui28LmA26K+E+byP0lOspAjXjSvokoDpSW7wdnNT1xk=";
          })
        ];
      });

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
