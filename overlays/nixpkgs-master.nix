{ flake }:
_final: prev:
let
  nixpkgs-master-packages = flake.inputs.nixpkgs-master.legacyPackages.${prev.stdenv.system};
  inherit (nixpkgs-master-packages) vimPlugins;
in
{
  inherit (nixpkgs-master-packages)
    luaPackages
    ;
  vimPlugins = vimPlugins // {
    #
    # Specific package overlays need to go in here to not get ignored
    #
  };
}
