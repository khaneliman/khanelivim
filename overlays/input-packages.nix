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

  vimPlugins = vimPlugins.extend (
    _self: super: {
      #
      # Specific package overlays need to go in here to not get ignored
      #
      fzf-lua = super.fzf-lua.overrideAttrs {
        doCheck = false;
      };

      grug-far-nvim = super.grug-far-nvim.overrideAttrs {
        doCheck = false;
      };

      neotest = super.neotest.overrideAttrs {
        doCheck = false;
      };

      snacks-nvim = super.snacks-nvim.overrideAttrs (_oldAttrs: {
        version = flake.inputs.snacks-nvim.shortRev;
        src = flake.inputs.snacks-nvim;
        # nvimSkipModules = oldAttrs.nvimSkipModules ++ [
        # ];
      });
    }
  );
}
