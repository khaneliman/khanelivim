{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Software inputs
    blink-cmp.url = "github:saghen/blink.cmp";
    blink-compat = {
      url = "github:saghen/blink.compat";
      flake = false;
    };
    blink-emoji = {
      url = "github:moyiz/blink-emoji.nvim";
      flake = false;
    };
    nixpkgs-tree-sitter.url = "github:khaneliman/nixpkgs/treesitter";
  };

  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      imports = [ ./flake-modules ];
    };
}
