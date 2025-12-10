{
  inputs,
  self,
  ...
}:
let
  mkNixvimConfig =
    {
      system,
      profile ? "full",
    }:
    inputs.nixvim.lib.evalNixvim {
      inherit system;

      extraSpecialArgs = {
        inherit inputs system self;
      };

      modules = [
        self.nixvimModules.default
        { khanelivim.profile = profile; }
      ];
    };
in
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
    {
      nixvimConfigurations = {
        # Full featured (default)
        khanelivim = mkNixvimConfig { inherit system; };

        # Profile variants for performance testing
        minimal = mkNixvimConfig {
          inherit system;
          profile = "minimal";
        };

        basic = mkNixvimConfig {
          inherit system;
          profile = "basic";
        };

        standard = mkNixvimConfig {
          inherit system;
          profile = "standard";
        };

        # Debug variant with all optimizations disabled
        debug = mkNixvimConfig {
          inherit system;
          profile = "debug";
        };
      };
    };
}
