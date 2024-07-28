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

    settings = {
      spec = [
        {
          __unkeyed = "<leader>b";
          group = "󰓩 Buffers";
        }
        {
          __unkeyed = "<leader>bs";
          group = "󰒺 Sort";
        }
        {
          __unkeyed = "<leader>d";
          group = "  Debug";
        }
        {
          __unkeyed = "<leader>g";
          group = "󰊢 Git";
        }
        {
          __unkeyed = "<leader>f";
          group = " Find";
        }
        {
          __unkeyed = "<leader>r";
          group = " Refactor";
        }
        {
          __unkeyed = "<leader>t";
          group = " Terminal";
        }
        {
          __unkeyed = "<leader>u";
          group = " UI/UX";
        }
      ];
    };

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

    window = {
      border = "single";
    };
  };
}
