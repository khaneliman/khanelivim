{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    ./apps
    ./docs.nix
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
          allowAliases = false;
          allowUnfree = true;
          permittedInsecurePackages = [
            # FIXME: pnpm 9 unsafe ignore for stylelint-lsp.
            "pnpm-9.15.9"
          ];
        };
      };

      packages.default = config.nixvimConfigurations.khanelivim.config.build.package;
    };
}
