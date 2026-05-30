{ inputs, lib, ... }:
let
  overlayFiles = lib.pipe ../overlays [
    builtins.readDir
    (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name))
    builtins.attrNames
  ];
in
{
  flake.overlays = lib.listToAttrs (
    map (filename: {
      name = lib.removeSuffix ".nix" filename;
      value = import (../overlays + "/${filename}") { flake = inputs.self; };
    }) overlayFiles
  );
}
