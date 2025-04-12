{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    ./nixvim.nix
    ./overlays.nix
    ./pkgs-by-name.nix
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions = {
    dev = {
      module = ./dev;
      extraInputsFlake = ./dev;
    };
  };

  # Specify which outputs are defined by which partitions
  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };

  perSystem =
    {
      config,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
        config.allowUnfree = true;
      };

      packages.default = config.packages.khanelivim;
    };
}
