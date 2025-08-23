{ lib, self, ... }:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) foldlAttrs;
  inherit (lib.lists) optional;
  by-name = ./plugins;
in
{
  # Plugin by-name directory imports
  imports =
    (foldlAttrs (
      prev: name: type:
      prev ++ optional (type == "directory") (by-name + "/${name}")
    ) [ ] (readDir by-name))
    ++ [
      # keep-sorted start
      ../khanelivim/options.nix
      ./autocommands.nix
      ./diagnostics.nix
      ./ft.nix
      ./keymappings.nix
      ./lsp.nix
      ./lua.nix
      ./options.nix
      ./performance.nix
      ./usercommands.nix
      # keep-sorted end
    ];

  nixpkgs = {
    overlays = lib.attrValues self.overlays;
    config.allowUnfree = true;
  };
}
