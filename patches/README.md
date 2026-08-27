# Input patches

This directory contains short-lived patches for flake inputs. The helper in
`flake/input-patches.nix` creates patched source trees before their Nix code is
evaluated.

Each `patches/<input>/default.nix` returns local patch paths, patch derivations,
or `fetchpatch2` argument sets. Remote patches must use immutable commit URLs
and fixed hashes. A `fetcher` attribute can select another Nixpkgs patch fetcher
when required.

Input patching imports a derivation-backed source tree. Keep
import-from-derivation enabled while any patch is active. Remove each patch
after the locked input contains its upstream commit. After removing the final
patch, set `allow-import-from-derivation = false` again.

## Cross-system evaluation

The patch derivation uses the package set supplied by its caller. Evaluating a
different target system therefore requires a compatible local, emulated, or
remote builder. Pure flake evaluation cannot select the evaluator's host system.
Use a pre-patched flake input when cross-system evaluation must work without a
target-system builder.
