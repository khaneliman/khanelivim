# Top-level flake glue to get our configuration working
{
  inputs,
  lib,
  root,
  self,
  ...
}:

{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem =
    {
      self',
      system,
      ...
    }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
        config.allowUnfree = true;
      };
    in
    {
      _module.args.pkgs = pkgs;

      checks.nixvim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule {
        inherit pkgs;

        extraSpecialArgs = {
          inherit self system inputs;
        };

        module = {
          imports = [ (root + /modules/nixvim) ];
        };
      };

      packages.default = self'.packages.khanelivim;
    };
}
