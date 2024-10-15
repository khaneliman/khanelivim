_: _final: prev: {
  nufmt = prev.rustPlatform.buildRustPackage {
    pname = "nufmt";
    version = "0-unstable-2024-10-15";

    src = prev.fetchFromGitHub {
      owner = "nushell";
      repo = "nufmt";
      rev = "37b473be178fd752b5bf421f8b20f48209e9c2ec";
      hash = "sha256-BrVWw6oklG70UomKDv5IBvoFIjtpajHKV37fh4fnK3E=";
    };

    buildInputs = prev.lib.optionals prev.stdenv.hostPlatform.isDarwin (
      with prev.darwin.apple_sdk.frameworks; [ IOKit ]
    );

    cargoHash = "sha256-eKQJanQ9ax5thc2DuO0yIgovor+i5Soylw58I2Y5cHw=";

    meta = {
      description = "Nushell formatter";
      homepage = "https://github.com/nushell/nufmt";
      license = prev.lib.licenses.mit;
      maintainers = with prev.lib.maintainers; [
        iogamaster
        khaneliman
      ];
      mainProgram = "nufmt";
    };
  };
}
