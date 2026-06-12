{ lib, pkgs, ... }:
{
  plugins = {
    # nixvim (nvim-nix) documentation
    # See: https://github.com/nix-community/nixvim
    direnv.enable = lib.mkDefault pkgs.stdenv.hostPlatform.isLinux;
    nix.enable = lib.mkDefault true;
    nix-develop.enable = lib.mkDefault true;
  };
}
