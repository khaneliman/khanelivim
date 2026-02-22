{
  config,
  lib,
  ...
}:
{
  plugins = lib.mkIf (config.khanelivim.ui.theme == "tokyonight") {
    lualine.settings.options.theme = "tokyonight";

    bufferline.settings = {
      highlights =
        let
          # Tokyo Night palette colors for bufferline
          # Using Tokyo Night's night style colors
          commonBgColor = "#3b4261"; # bg_highlight - slightly lighter for selected
          commonFgColor = "#1a1b26"; # bg - base background

          commonSelectedAttrs = {
            bg = commonBgColor;
          };

          # Define common selected attributes for all buffer states
          selectedAttrsSet = builtins.listToAttrs (
            map
              (name: {
                inherit name;
                value = commonSelectedAttrs;
              })
              [
                "buffer_selected"
                "tab_selected"
                "numbers_selected"
                "close_button_selected"
                "duplicate_selected"
                "modified_selected"
                "info_selected"
                "warning_selected"
                "error_selected"
                "hint_selected"
                "diagnostic_selected"
                "info_diagnostic_selected"
                "warning_diagnostic_selected"
                "error_diagnostic_selected"
                "hint_diagnostic_selected"
              ]
          );
        in
        selectedAttrsSet
        // {
          fill = {
            bg = commonFgColor;
          };
          separator = {
            fg = commonFgColor;
          };
          separator_visible = {
            fg = commonFgColor;
          };
          separator_selected = {
            bg = commonBgColor;
            fg = commonFgColor;
          };
        };
    };
  };

  colorschemes.tokyonight = {
    # tokyonight.nvim documentation
    # See: https://github.com/folke/tokyonight.nvim
    enable = config.khanelivim.ui.theme == "tokyonight";

    lazyLoad.enable = config.plugins.lz-n.enable;

    settings = {
      transparent = true;
      style = "night";
      light_style = "day";
    };
  };
}
