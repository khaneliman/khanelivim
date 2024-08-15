{
  inputs,
  lib,
  pkgs,
  system,
}:
let
  inherit (inputs) nixvim;
in
nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule {
  inherit pkgs;

  module = {
    imports = lib.snowfall.fs.get-non-default-nix-files-recursive ../../packages/khanelivim;
  };
}
