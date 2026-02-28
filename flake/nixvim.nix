{
  inputs,
  lib,
  self,
  ...
}:
let
  mkNixvimConfig =
    {
      system,
      profile ? "full",
    }:
    let
      sharedNixpkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          # Keep this aligned with modules/nixvim/default.nix semantics while
          # using externally provided nixpkgs.pkgs for eval deduplication.
          allowAliases = false;
          allowUnfree = true;
        };
      };
    in
    inputs.nixvim.lib.evalNixvim {
      inherit system;

      extraSpecialArgs = {
        inherit inputs system self;
      };

      modules = [
        self.nixvimModules.default
        {
          nixpkgs.pkgs = lib.mkDefault sharedNixpkgs;
          nixpkgs.config = lib.mkForce { };
          khanelivim.profile = profile;
        }
      ];
    };
in
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = false;
    checks.enable = false;
  };

  flake = {
    nixvimModules.default = ../modules/nixvim;
    lib = {
      inherit mkNixvimConfig;
      mkNixvimPackage = args: (mkNixvimConfig args).config.build.package;
      mkNixvimTest = args: (mkNixvimConfig args).config.build.test;
    };
  };

  perSystem =
    { system, ... }:
    let
      defaultConfig = mkNixvimConfig { inherit system; };
    in
    {
      nixvimConfigurations = {
        # Full featured (default)
        khanelivim = defaultConfig;
      };

      checks.khanelivim = defaultConfig.config.build.test;
    };
}
