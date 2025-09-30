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
        rev = "7b3d28bbb883e898f6a8b4f2d7a9ab6ad5cef9f8";
        sha256 = "1m2af27xvagdq6q8kyahcsrbraaw4x2yvrg35xxcpgp0vi0m9h6a";
      };
    };
  };
}
