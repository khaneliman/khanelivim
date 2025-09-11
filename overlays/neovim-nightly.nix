{ flake }:
_final: prev: {
  neovim-unwrapped = flake.inputs.neovim-nightly-overlay.packages.${prev.stdenv.system}.default;
}
