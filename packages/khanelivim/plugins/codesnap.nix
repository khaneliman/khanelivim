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

  keymaps = lib.mkIf config.plugins.codesnap.enable [
    {
      mode = "v";
      key = "<leader>cs";
      action = ":CodeSnap<CR>";
      options = {
        desc = "Copy";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<leader>cS";
      action = ":CodeSnapSave<CR>";
      options = {
        desc = "Save";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<leader>ch";
      action = ":CodeSnapHighlight<CR>";
      options = {
        desc = "Highlight";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<leader>cH";
      action = ":CodeSnapSaveHighlight<CR>";
      options = {
        desc = "Save Highlight";
        silent = true;
      };
    }
  ];
}
