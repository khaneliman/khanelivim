{ flake }:
_final: super: {
  yazi = flake.inputs.yazi.packages.${super.stdenv.system}.default;
}
