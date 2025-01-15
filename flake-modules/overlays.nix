{ inputs, lib, ... }:
{
  flake.overlays = lib.listToAttrs (
    map (file: {
      name = "${lib.removeSuffix ".nix" (builtins.hashString "sha256" file)}-overlay";
      value = import file { flake = inputs.self; };
    }) (inputs.self.lib.khanelivim.readAllFiles ../overlays)
  );
}
