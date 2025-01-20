{ flake }:
_self: super: {
  inherit (flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system})
    # Fixes codelldb
    llvmPackages_14
    llvmPackages_15
    llvmPackages_16
    llvmPackages_17
    # Fix ruff
    ruff
    # Fixes hard freeze
    tree-sitter
    # Latest bump
    vimPlugins
    ;
}
