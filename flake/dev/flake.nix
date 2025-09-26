{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";

  inputs = {
    root = {
      url = "path:../../";
      # Unneeded for dev flake
      inputs = {
        pkgs-by-name-for-flake-parts.follows = "";
        neovim-nightly-overlay.follows = "";
        nixvim.follows = "";
      };
    };
    nixpkgs.follows = "root/nixpkgs";

    # keep-sorted start block=yes newline_separated=no
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # Optional inputs removed
        gitignore.follows = "";
        flake-compat.follows = "";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };

  outputs = _inputs: { };
}
