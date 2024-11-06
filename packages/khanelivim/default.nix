{
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
let
  inherit (inputs) nixvim;
in
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  extraSpecialArgs = {
    inherit (inputs) self;
  };

  module = {
    imports = lib.snowfall.fs.get-non-default-nix-files-recursive ./.;
  };
}
