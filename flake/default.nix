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

  flake.templates = {
    nixvim-upstream-plugin = {
      path = ../templates/nixvim-upstream-plugin;
      description = "Template for adding a nixvim upstream plugin module";
    };

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
        config = {
          allowUnfree = true;
          allowAliases = false;
        };
      };

      packages.default = config.packages.khanelivim;
    };
}
