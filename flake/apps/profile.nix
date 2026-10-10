_: {
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      apps.profile =
        let
          profilerScript = builtins.readFile ./scripts/profile_nvim.py;
          profiler = pkgs.writers.writePython3Bin "profile-nvim" {
            flakeIgnore = [ "E501" ];
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
