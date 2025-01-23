{ flake }:
_final: super: {
  inherit (flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system})
    # TODO: remove after https://nixpk.gs/pr-tracker.html?pr=375948 reaches nixpkgs-unstable
    luaPackages

    lua51Packages
    lua52Packages
    lua53Packages
    lua54Packages
    luajitPackage
    ;
}
