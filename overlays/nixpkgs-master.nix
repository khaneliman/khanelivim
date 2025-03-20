{ flake }:
_final: super:
let
  nixpkgs-master-packages = flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system};
in
{
  inherit (nixpkgs-master-packages)
    luaPackages
    ;
  vimPlugins = nixpkgs-master-packages.vimPlugins // {
    #
    # Specific package overlays need to go in here to not get ignored
    #

    git-worktree-nvim = nixpkgs-master-packages.vimPlugins.git-worktree-nvim.overrideAttrs {
      patches = [
        (super.fetchpatch {
          name = "fix-hl-error";
          url = "https://patch-diff.githubusercontent.com/raw/ThePrimeagen/git-worktree.nvim/pull/132.patch";
          hash = "sha256-RF+SijBfI7KlN2bsx/qYDGQfXc18cydm7x6BijCIfYM=";
        })
      ];
    };
  };
}
