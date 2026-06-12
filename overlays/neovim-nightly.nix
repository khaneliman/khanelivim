{ flake }:
_final: prev: {
  # Nightly source already contains the CVE-2026-11487 fix, so the nixpkgs
  # patch fails to apply. Drop the filter once nixpkgs-unstable includes
  # https://github.com/NixOS/nixpkgs/commit/4c1fb8659a (0.12.3 bump removing it).
  neovim-unwrapped =
    flake.inputs.neovim-nightly-overlay.packages.${prev.stdenv.system}.default.overrideAttrs
      (old: {
        patches = builtins.filter (patch: !prev.lib.hasInfix "CVE-2026-11487" (toString patch)) (
          old.patches or [ ]
        );
      });
}
