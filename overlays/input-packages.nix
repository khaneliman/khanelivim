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
    neovim-unwrapped
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
    blink-cmp-yanky = prev.callPackage ../packages/blink-cmp-yanky/package.nix { };

    snacks-nvim = vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = flake.inputs.snacks-nvim.shortRev;
      src = flake.inputs.snacks-nvim;
      nvimSkipModules = oldAttrs.nvimSkipModules ++ [
        "snacks.gh.init"
        "snacks.gh.actions"
        "snacks.gh.buf"
        "snacks.gh.render"
        "snacks.gh.render.init"
        "snacks.picker.source.gh"
        "snacks.picker.util.diff"
      ];
    });
  };
}
