{
  inputs,
  pkgs,
  system,
  ...
}:
inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;

  extraSpecialArgs = {
    inherit inputs system;
    inherit (inputs) self;
  };

  module = {
    imports = [ ../../modules/nixvim ];

    nixpkgs.pkgs = pkgs;
  };
}
