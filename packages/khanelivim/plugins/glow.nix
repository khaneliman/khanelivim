{ pkgs, lib, ... }:
let
  stylePkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "glamour";
    rev = "66d7b09325af67b1c5cdb063343e829c04ad7d5f";
    hash = "sha256-f3JFgqL3K/u8U/UzmBohJLDBPlT446bosRQDca9+4oA=";
  };

  # TODO: use theme module
  style = "${stylePkg.outPath}/themes/catppuccin-macchiato.json";
in
{
  # home.file = mkIf pkgs.stdenv.isDarwin { "Library/Preferences/glow/glow.yml".text = config; };

  # xdg.configFile = mkIf pkgs.stdenv.isLinux { "glow/glow.yml".text = config; };

  extraPlugins = with pkgs.vimPlugins; [ glow-nvim ];

  extraConfigLuaPre = ''
    require('glow').setup({
      border = "single";
      glow_path = "${lib.getExe pkgs.glow}";
      style = "${style}";
    });
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>pg";
      action = ":Glow<CR>";
      options = {
        desc = "Glow (Markdown)";
        silent = true;
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>p";
      mode = "n";
      group = "Preview";
      icon = " ";
    }
  ];
}
