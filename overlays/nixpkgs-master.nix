{ flake }:
_final: super:
let
  nixpkgs-master-packages = flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system};
  inherit (nixpkgs-master-packages) vimPlugins;
in
{
  inherit (nixpkgs-master-packages)
    luaPackages
    ;
  vimPlugins = vimPlugins // {
    #
    # Specific package overlays need to go in here to not get ignored
    #

    blink-nvim = flake.inputs.blink-cmp.packages.${super.stdenv.system}.default;

    git-worktree-nvim = super.vimUtils.buildVimPlugin rec {
      pname = "git-worktree.nvim";
      version = "2.1.0";
      src = super.fetchFromGitHub {
        owner = "polarmutex";
        repo = "git-worktree.nvim";
        tag = version;
        hash = "sha256-fnqJqQTNei+8Gk4vZ2hjRj8iHBXTZT15xp9FvhGB+BQ=";
      };
      dependencies = [ vimPlugins.plenary-nvim ];
      meta.homepage = "https://github.com/polarmutex/git-worktree.nvim/";
    };
  };
}
