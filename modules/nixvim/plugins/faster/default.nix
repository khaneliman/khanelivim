{
  config,
  lib,
  ...
}:
{
  imports = [
    ./features.nix
    ./keymaps.nix
  ];

  plugins = {
    faster = {
      enable = lib.elem "faster" config.khanelivim.performance.optimizer;

      lazyLoad.settings = {
        event = [
          "DeferredUIEnter"
        ];
      };

      settings = {
        behaviours = {
          bigfile = {
            on = true;
            features_disabled = [
              "filetype"
              "lsp"
              "matchparen"
              "syntax"
              "treesitter"
              "vimopts"
            ]
            ++ lib.optionals config.plugins.bufferline.enable [ "bufferline" ]
            ++ lib.optionals config.plugins.gitsigns.enable [ "gitsigns" ]
            ++ lib.optionals config.plugins.mini-indentscope.enable [ "mini_indentscope" ]
            ++ lib.optionals config.plugins.blink-indent.enable [ "blink_indent" ]
            ++ lib.optionals config.plugins.noice.enable [ "noice" ]
            ++ lib.optionals config.plugins.snacks.enable [ "snacks" ];
            filesize = 2;
            pattern = "*";
            extra_patterns = [
              # More aggressive for log files
              {
                filesize = 1;
                pattern = "*.log";
              }
              # Even more aggressive for large data files
              {
                filesize = 0.5;
                pattern = "*.{csv,json,xml}";
              }
              # Markdown files can get large with embedded content
              {
                filesize = 1.5;
                pattern = "*.md";
              }
            ];
          };

          bigfile_hugefiles = {
            on = true;
            features_disabled = [
              "lualine"
            ]
            ++ lib.optionals config.plugins.bufferline.enable [ "bufferline" ]
            ++ lib.optionals config.plugins.mini-indentscope.enable [ "mini_indentscope" ]
            ++ lib.optionals config.plugins.blink-indent.enable [ "blink_indent" ]
            ++ lib.optionals config.plugins.noice.enable [ "noice" ];
          };
        };
      };
    };
  };
}
