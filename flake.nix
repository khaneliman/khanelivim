{
  description = "KhaneliVim";

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      # url = "github:nixos/nixpkgs/nixpkgs-unstable";
      url = "github:nixos/nixpkgs/master";
      # url = "github:khaneliman/nixpkgs/vim";
      # url = "git+file:///home/khaneliman/Documents/github/NixOS/nixpkgs";
    };

    # Neovim nix configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      # url = "github:khaneliman/nixvim/lazy-complex";
      # url = "git+file:///Users/khaneliman/github/nixvim";
      # url = "git+file:///home/khaneliman/Documents/github/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix.url = "github:cachix/git-hooks.nix";

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

    blink-cmp = {
      url = "github:saghen/blink.cmp";
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
