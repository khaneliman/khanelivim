{ pkgs, ... }:
{
  plugins = {
    # FIXME: fish broken darwin
    direnv.enable = pkgs.stdenv.hostPlatform.isLinux;
    nix.enable = true;
    nix-develop.enable = true;
  };
}
