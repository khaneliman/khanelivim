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
      # glow.nvim documentation
      # See: https://github.com/ellisonleao/glow.nvim
      enable = lib.elem "glow" config.khanelivim.documentation.viewers;

      lazyLoad.settings.ft = "markdown";

      settings = {
        border = "single";
        style = "${stylePkg.outPath}/themes/catppuccin-macchiato.json";
      };
    };

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
