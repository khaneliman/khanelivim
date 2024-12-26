_: _final: prev: {
  deno = prev.deno.overrideAttrs (_oldAttrs: {
    buildInputs = [ prev.libffi ];

    postPatch = ''
      # upstream uses lld on aarch64-darwin for faster builds
      # within nix lld looks for CoreFoundation rather than CoreFoundation.tbd and fails
      substituteInPlace .cargo/config.toml --replace-fail "-fuse-ld=lld " ""

      # Use patched nixpkgs libffi in order to fix https://github.com/libffi/libffi/pull/857
      substituteInPlace ext/ffi/Cargo.toml --replace-fail "libffi = \"=3.2.0\"" "libffi = { version = \"3.2.0\", features = [\"system\"] }"
    '';
  });
}
