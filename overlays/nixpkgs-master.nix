{ flake }:
_final: super:
let
  nixpkgs-master-packages = flake.inputs.nixpkgs-master.legacyPackages.${super.stdenv.system};
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

    blink-nvim = flake.inputs.blink-cmp.packages.${super.stdenv.system}.default;
  };
}
