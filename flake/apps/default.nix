_: {
  imports = [
    ./update.nix
    ./grammar-sizes.nix
    ./check-duplicates.nix
    ./pack-dir.nix
    ./profile.nix
  ];

  perSystem = _: {
    _module.args.profileBuildCommandPython = ''
      def build_command_for_profile(profile):
          """Build command for a profile without requiring .#profile attrs"""
          if profile == "default":
              return "nix build --no-link --print-out-paths .#default"
          expr = (
              "let f = builtins.getFlake (toString ./.); "
              "in (f.lib.mkNixvimPackage { "
              f"system = builtins.currentSystem; profile = \"{profile}\"; "
              "})"
          )
          return (
              "nix build --impure --no-link --print-out-paths --expr "
              f"'{expr}'"
          )
    '';
  };
}
