specialArgs: _self: super: {
  inherit (specialArgs.flake.inputs.nixpkgs-vim.legacyPackages.${super.stdenv.system})
    vimPlugins
    ;
}
