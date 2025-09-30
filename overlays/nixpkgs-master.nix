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
      version = "2025-09-30";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "sidekick.nvim";
        rev = "d11ee7f7209d3417d1bc007f387b665db43117bc";
        sha256 = "0kkmyfsfwd2xa7gfzp58439mnf01v48z79bislzw2j81i8jk78zv";
      };
    };
  };
}
