specialArgs: _self: super: {
  inherit (specialArgs.flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system})
    llvmPackages_14
    llvmPackages_15
    llvmPackages_16
    llvmPackages_17
    ruff
    tree-sitter
    ;
}
