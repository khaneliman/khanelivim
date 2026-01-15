{
  pkgs,
  lib,
  config,
  ...
}:
{
  plugins = {
    codesnap = {
      enable = lib.elem "codesnap" config.khanelivim.utilities.screenshots;
      package = pkgs.vimPlugins.codesnap-nvim;

      lazyLoad = {
        settings = {
          cmd = [
            "CodeSnap"
            "CodeSnapSave"
            "CodeSnapHighlight"
            "CodeSnapSaveHighlight"
          ];
        };
      };

      settings = {
        snapshot_config = {
          code_config = {
            font_family = "MonaspiceNe Nerd Font";
            breadcrumbs = {
              enable = true;
              separator = "/";
            };
          };
          show_line_number = false;
          snapshot_config = {
            window = {
              mac_window_bar = true;
            };
          };
          watermark.content = "";
        };
      };
    };

  };

  keymaps = lib.mkIf config.plugins.codesnap.enable [
    {
      mode = [
        "x"
        "v"
      ];
      key = "<leader>cc";
      action = "<Esc><cmd>CodeSnap<CR>";
      options = {
        desc = "Copy";
      };
    }
    {
      mode = [
        "x"
        "v"
      ];
      key = "<leader>cs";
      action = "<Esc><cmd>CodeSnapSave<CR>";
      options = {
        desc = "Save";
      };
    }
    {
      mode = [
        "x"
        "v"
      ];
      key = "<leader>ch";
      action = "<Esc><cmd>CodeSnapHighlight<CR>";
      options = {
        desc = "Highlight";
      };
    }
    {
      mode = [
        "x"
        "v"
      ];
      key = "<leader>cH";
      action = "<Esc><cmd>CodeSnapSaveHighlight<CR>";
      options = {
        desc = "Save Highlight";
      };
    }
  ];
}
