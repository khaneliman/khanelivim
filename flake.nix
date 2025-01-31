{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
    nixvim.url = "github:nix-community/nixvim";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Software inputs
    avante-nvim = {
      url = "github:yetone/avante.nvim";
      flake = false;
    };
    blink-copilot = {
      url = "github:fang2hou/blink-copilot";
      flake = false;
    };
    blink-cmp.url = "github:saghen/blink.cmp";
    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    nixpkgs-master.url = "github:nixos/nixpkgs";
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

      imports = [ ./flake ];
    };
}
