{ pkgs, ... }:
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
  plugins = {
    glow = {
      enable = true;

      settings = {
        border = "single";
        style = "${style}";
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed = "<leader>p";
        mode = "n";
        group = "Preview";
        icon = " ";
      }
    ];
  };

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
}
