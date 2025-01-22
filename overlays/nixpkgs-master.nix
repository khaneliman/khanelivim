{ flake }:
_self: super: {
  inherit (flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system})
    # Latest bump
    vimPlugins
    tree-sitter
    ;
}
