{ flake }:
_final: prev: {
  yazi = flake.inputs.yazi.packages.${prev.stdenv.system}.default;
}
