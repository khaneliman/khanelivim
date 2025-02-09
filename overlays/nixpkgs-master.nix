{ flake }:
_final: super: {
  inherit (flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system})
    luaPackages
    vimPlugins
    ;
}
