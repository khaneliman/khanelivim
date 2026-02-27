{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    ./apps
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
        config = {
          allowUnfree = true;
          # NOTE: Keep aliases enabled for the main flake pkgs path for now.
          # `allowAliases = false` currently breaks git-hooks-nix installation.
          # Nixvim eval config sets allowAliases explicitly in flake/nixvim.nix.
          # FIXME: unify this once the git-hooks issue is resolved.
          # allowAliases = false;
        };
      };

      packages.default = config.packages.khanelivim;
    };
}
