{
  pkgs,
  lib,
  config,
  ...
}:
{
  plugins = {
    codesnap = {
      enable = true;
      package = pkgs.vimPlugins.codesnap-nvim;

      lazyLoad = {
        settings = {
          cmd = [
            "CodeSnap"
            "CodeSnapSave"
            "CodeSnapHighlight"
            "CodeSnapSaveHighlight"
          ];
          keys = [
            {
              __unkeyed-1 = "<leader>cc";
              __unkeyed-3 = "<cmd>CodeSnap<CR>";
              desc = "Copy";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>cs";
              __unkeyed-3 = "<cmd>CodeSnapSave<CR>";
              desc = "Save";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>ch";
              __unkeyed-3 = "<cmd>CodeSnapHighlight<CR>";
              desc = "Highlight";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>cH";
              __unkeyed-3 = "<cmd>CodeSnapSaveHighlight<CR>";
              desc = "Save Highlight";
              mode = "v";
            }
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
        __unkeyed = "<leader>c";
        mode = "v";
        group = "Codesnap";
        icon = "󰄄 ";
      }
    ];
  };

  keymaps = lib.mkIf (config.plugins.codesnap.enable && !config.plugins.lz-n.enable) [
    {
      mode = "v";
      key = "<leader>cc";
      action = "<cmd>CodeSnap<CR>";
      options = {
        desc = "Copy";
      };
    }
    {
      mode = "v";
      key = "<leader>cs";
      action = "<cmd>CodeSnapSave<CR>";
      options = {
        desc = "Save";
      };
    }
    {
      mode = "v";
      key = "<leader>ch";
      action = "<cmd>CodeSnapHighlight<CR>";
      options = {
        desc = "Highlight";
      };
    }
    {
      mode = "v";
      key = "<leader>cH";
      action = "<cmd>CodeSnapSaveHighlight<CR>";
      options = {
        desc = "Save Highlight";
      };
    }
  ];
}
