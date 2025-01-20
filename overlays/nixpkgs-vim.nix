{ flake }:
_self: super: {
  inherit (flake.inputs.nixpkgs-vim.legacyPackages.${super.stdenv.system})
    vimPlugins
    ;
}
