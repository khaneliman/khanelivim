specialArgs: _self: super: {
  inherit (specialArgs.flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system})
    ruff
    tree-sitter
    ;
}
