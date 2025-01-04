{
  # TODO: proper auto importing
  # imports = (with builtins; map (fn: ./${fn}) (attrNames (readDir ./.)));
  imports = [
    ./autocommands.nix
    ./diagnostics.nix
    ./ft.nix
    ./keymappings.nix
    ./lua.nix
    ./options.nix
    ./performance.nix
    ./usercommands.nix
  ] ++ (with builtins; map (fn: ./plugins/${fn}) (attrNames (readDir ./plugins)));
}
