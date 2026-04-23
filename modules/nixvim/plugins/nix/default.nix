{ pkgs, ... }:
{
  plugins = {
    # nixvim (nvim-nix) documentation
    # See: https://github.com/nix-community/nixvim
    direnv.enable = pkgs.stdenv.hostPlatform.isLinux;
    nix.enable = true;
    nix-develop.enable = true;
  };
}
