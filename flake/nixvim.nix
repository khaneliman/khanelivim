{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  flake.nixvimModules = {
    default = ../modules/nixvim;
  };

  perSystem =
    { system, ... }:
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

      mkNixvimConfig =
        {
          profile ? "full",
        }:
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
      nixvimConfigurations = {
        # Full featured (default)
        khanelivim = mkNixvimConfig { };

        # Profile variants for performance testing
        minimal = mkNixvimConfig {
          profile = "minimal";
        };

        basic = mkNixvimConfig {
          profile = "basic";
        };

        standard = mkNixvimConfig {
          profile = "standard";
        };

        # Debug variant with all optimizations disabled
        debug = mkNixvimConfig {
          profile = "debug";
        };
      };
    };
}
