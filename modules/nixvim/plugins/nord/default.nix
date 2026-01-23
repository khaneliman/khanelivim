{
  config,
  lib,
  ...
}:
{
  plugins = lib.mkIf (config.khanelivim.ui.theme == "nord") {
    lualine.settings.options.theme = "nord";

    bufferline.settings = {
      highlights =
        let
          # Nord palette colors for bufferline
          # Using Nord's snow storm (lighter) and polar night (darker) colors
          commonBgColor = "#434c5e"; # nord2 - slightly lighter for selected
          commonFgColor = "#2e3440"; # nord0 - base background

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

  colorschemes.nord = {
    enable = config.khanelivim.ui.theme == "nord";

    lazyLoad.enable = config.plugins.lz-n.enable;

    settings = {
      transparent = true;

      # Fix nvim-notify background when using transparent background
      # Nord doesn't set NotifyBackground highlight group with transparent = true
      on_highlights.__raw = ''
        function(highlights, colors)
          -- Set background for nvim-notify to avoid "no background" warning
          highlights.NotifyBackground = { bg = colors.polar_night.origin }
        end
      '';
    };
  };
}
