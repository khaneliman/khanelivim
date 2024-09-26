{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylePkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "glamour";
    rev = "f410083af1e9b2418bcd73dbbbc987461d4aa292";
    hash = "sha256-a7yR19KcxIS4UPhuhB+X0B+s8D5eytw0/EB0X4z46kA=";
  };
in
{
  plugins = {
    glow = {
      enable = true;

      settings = {
        border = "single";
        style = "${stylePkg.outPath}/themes/catppuccin-macchiato.json";
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

  keymaps = lib.optionals config.plugins.glow.enable [
    {
      mode = "n";
      key = "<leader>pg";
      action = "<cmd>Glow<CR>";
      options = {
        desc = "Glow (Markdown)";
      };
    }
  ];
}
