{
  description = "KhaneliVim";

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
      # url = "git+file:///home/khaneliman/Documents/github/NixOS/nixpkgs";
    };

    # Neovim nix configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      # url = "git+file:///Users/khaneliman/Documents/github/nixvim";
      # url = "git+file:///home/khaneliman/Documents/github/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";

    # Snowfall Lib
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blink-compat = {
      url = "github:saghen/blink.compat";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs) snowfall-lib;

      lib = snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "khanelivim";
            title = "khanelivim";
          };

          namespace = "khanelivim";
        };
      };
    in
    lib.mkFlake {
      alias = {
        packages = {
          default = "khanelivim";
          nvim = "khanelivim";
        };
      };

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "dotnet-core-combined"
          "dotnet-sdk-6.0.428"
          "dotnet-sdk-7.0.410"
          "dotnet-sdk-wrapped-6.0.428"
        ];
      };

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    }
    // {
      inherit (inputs) self;
    };
}
