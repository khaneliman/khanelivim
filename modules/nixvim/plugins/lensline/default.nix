{
  config,
  lib,
  ...
}:
{
  config = {
    plugins.lensline = {
      # lensline.nvim documentation
      # See: https://github.com/oribarilan/lensline.nvim
      enable = true;

      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];

      settings = {
        profiles = [
          {
            name = "default";
            providers = [
              {
                name = "usages";
                enabled = true;
                include = [ "refs" ];
                breakdown = false;
                show_zero = true;
              }
              {
                name = "last_author";
                enabled = true;
                cache_max_files = 100;
              }
              {
                name = "diagnostics";
                enabled = true;
                min_level = "HINT";
              }
              {
                name = "complexity";
                enabled = true;
                min_level = "M";
              }
            ];
            style = {
              placement = "inline";
              prefix = "";
            };
          }
        ];
        limits = {
          exclude_gitignored = true;
          max_lines = 2000;
          max_lenses = 100;
        };
        debounce_ms = 300;
      };
    };

    keymaps = lib.mkIf config.plugins.lensline.enable [
      {
        mode = "n";
        key = "<leader>ueL";
        action = "<cmd>LenslineToggleEngine<CR>";
        options = {
          desc = "Lensline engine toggle";
        };
      }
      {
        mode = "n";
        key = "<leader>uel";
        action = "<cmd>LenslineToggleView<CR>";
        options = {
          desc = "Lensline view toggle";
        };
      }
    ];
  };
}
