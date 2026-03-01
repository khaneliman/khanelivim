_: {
  perSystem =
    {
      pkgs,
      lib,
      profileBuildCommandPython,
      ...
    }:
    {
      apps.profile =
        let
          defaultProfileBuildCommandPython = ''
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
          profilerScript =
            builtins.replaceStrings [ defaultProfileBuildCommandPython ] [ profileBuildCommandPython ]
              (builtins.readFile ./scripts/profile_nvim.py);
          profiler = pkgs.writers.writePython3Bin "profile-nvim" {
            libraries = [ pkgs.python3Packages.rich ];
          } profilerScript;
          wrapped =
            pkgs.runCommand "profile-nvim"
              {
                nativeBuildInputs = [ pkgs.makeWrapper ];
                passthru.meta.mainProgram = "profile-nvim";
              }
              ''
                makeWrapper ${profiler}/bin/profile-nvim $out/bin/profile-nvim \
                  ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
                    --prefix PATH : ${lib.makeBinPath [ pkgs.xvfb-run ]}
                  ''}
              '';
        in
        {
          type = "app";
          program = lib.getExe wrapped;
          meta.description = "Profile khanelivim startup performance";
        };
    };
}
