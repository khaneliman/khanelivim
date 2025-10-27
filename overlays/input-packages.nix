{ flake }:
_final: prev:
let
  nixpkgs-master-packages = import flake.inputs.nixpkgs-master {
    inherit (prev.stdenv) system;
    config = {
      allowUnfree = true;
      allowAliases = false;
    };
  };
  # my-packages = flake.packages.${prev.stdenv.system};
  inherit (nixpkgs-master-packages) luaPackages vimPlugins;
in
{
  inherit (nixpkgs-master-packages)
    claude-code
    github-copilot-cli
    opencode
    ;

  luaPackages = luaPackages // {
    #
    # Specific package overlays need to go in here to not get ignored
    #
    fzf-lua = luaPackages.fzf-lua.override {
      doCheck = false;
    };

    grug-far-nvim = luaPackages.grug-far-nvim.override {
      doCheck = false;
    };

    neotest = luaPackages.neotest.override {
      doCheck = false;
    };
  };
  vimPlugins = vimPlugins // {
    #
    # Specific package overlays need to go in here to not get ignored
    #
    snacks-nvim = vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        inherit (oldAttrs.src) owner repo;
        rev = "d293b21fe1a603dfb4757feb82ab3e67b78589f2";
        hash = "sha256-CSiwn1xZNj5Gu03ddhOmCZKjnxEjwzkjpmeV0kJn0uE=";
      };
    });
    noice-nvim = vimPlugins.noice-nvim.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        inherit (oldAttrs.src) owner repo;
        rev = "c86aea584d98be7ee1167ce4d4ef946fbd7f3ae0";
        hash = "sha256-1BW1yQ8yd/HF127CAqIC7ZayJJ2T+j6YCXQWm3vHrhQ=";
      };
    });
  };
}
