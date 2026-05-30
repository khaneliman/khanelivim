{ lib, ... }:
let
  inherit (builtins) readDir;
  by-name = ./plugins;
in
{
  # Plugin by-name directory imports
  imports =
    (lib.mapAttrsToList (name: _: by-name + "/${name}") (
      lib.filterAttrs (_: type: type == "directory") (readDir by-name)
    ))
    ++ [
      # keep-sorted start
      ../khanelivim
      ./autocommands.nix
      ./dependencies.nix
      ./diagnostics.nix
      ./ft.nix
      ./keymappings.nix
      ./lsp.nix
      ./lua.nix
      ./options.nix
      ./performance.nix
      ./snippets
      ./usercommands.nix
      # keep-sorted end
    ];
}
