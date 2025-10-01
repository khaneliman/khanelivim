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
    sidekick-nvim = vimPlugins.sidekick-nvim.overrideAttrs {
      version = "2025-10-01";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "sidekick.nvim";
        rev = "8c940476cae4e2ba779ed6c73080d097694e406c";
        sha256 = "0qwi3kcsww7nax5nyi3yrxc20dc6n9qijqf5mrwy771aqv7ch3as";
      };
    };
  };
}
