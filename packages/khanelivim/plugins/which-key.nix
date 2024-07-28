{ pkgs, ... }:
{
  plugins.which-key = {
    enable = true;
    # TODO: remove override after nixpkgs gets bumped
    package = pkgs.vimPlugins.which-key-nvim.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = oldAttrs.src.owner;
        repo = oldAttrs.src.repo;
        rev = "6c1584eb76b55629702716995cca4ae2798a9cca";
        hash = "sha256-nv9s4/ax2BoL9IQdk42uN7mxIVFYiTK+1FVvWDKRnGM=";
      };
    });

    keyLabels = {
      "<space>" = "SPACE";
      "<leader>" = "SPACE";
      "<cr>" = "RETURN";
      "<CR>" = "RETURN";
      "<tab>" = "TAB";
      "<TAB>" = "TAB";
      "<bs>" = "BACKSPACE";
      "<BS>" = "BACKSPACE";
    };

    registrations = {
      "<leader>" = {
        "b" = {
          name = "󰓩 Buffers";
          s = "󰒺 Sort";
        };
        "d" = {
          name = "  Debug";
        };
        "g" = {
          name = "󰊢 Git";
        };
        "f" = {
          name = " Find";
        };
        "l" = {
          name = "  LSP";
          a = "Code Action";
          d = "Definition";
          D = "References";
          f = "Format";
          p = "Prev";
          n = "Next";
          t = "Type Definition";
          i = "Implementation";
          h = "Hover";
          r = "Rename";
        };
        "r" = {
          name = " Refactor";
        };
        "t" = {
          name = " Terminal";
        };
        "u" = {
          name = " UI/UX";
        };
      };
    };

    window = {
      border = "single";
    };
  };
}
