{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    ./devshell.nix
    ./git-hooks.nix
    ./treefmt.nix
  ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = lib.mkDefault (
        import inputs.nixpkgs {
          inherit system;
          overlays = lib.attrValues self.overlays;
          config.allowUnfree = true;
        }
      );
    };
}
