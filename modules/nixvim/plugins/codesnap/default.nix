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
        code_font_family = "MonaspiceNe Nerd Font";
        save_path = "$XDG_PICTURES_DIR/screenshots";
        mac_window_bar = true;
        title = "CodeSnap.nvim";
        watermark = "";
        breadcrumbs_separator = "/";
        has_breadcrumbs = true;
        has_line_number = false;
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.codesnap.enable [
      {
        __unkeyed-1 = "<leader>c";
        mode = "v";
        group = "Codesnap";
        icon = "󰄄 ";
      }
    ];
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
