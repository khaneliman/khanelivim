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
      pkgs ? null,
      profile ? "standard",
    }:
    let
      sharedNixpkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
        config = {
          allowAliases = false;
          allowUnfree = true;
        };
      };
      nixvimPkgs = if pkgs == null then sharedNixpkgs else pkgs;
    in
    inputs.nixvim.lib.evalNixvim {
      inherit system;

      extraSpecialArgs = {
        inherit inputs system self;
      };

      modules = [
        self.nixvimModules.default
        {
          nixpkgs.pkgs = lib.mkDefault nixvimPkgs;
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
    { pkgs, system, ... }:
    let
      defaultConfig = mkNixvimConfig { inherit pkgs system; };
    in
    {
      nixvimConfigurations = {
        # Recommended default profile
        khanelivim = defaultConfig;
      };

      checks.khanelivim = defaultConfig.config.build.test;
    };
}
