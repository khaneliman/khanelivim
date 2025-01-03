specialArgs: _self: super: {
  inherit (specialArgs.flake.inputs.nixpkgs-tree-sitter.legacyPackages.${super.stdenv.system})
    tree-sitter
    ;
}
