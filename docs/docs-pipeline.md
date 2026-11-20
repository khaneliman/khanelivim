# Docs Pipeline

This site is built directly from the flake and the profile evaluation logic.

## Pipeline Steps

1. Evaluate the `khanelivim.*` option tree with `mkNixvimConfig`.
2. Generate markdown for the `khanelivim` options reference.
3. Split the options reference into pages by the level below `khanelivim`.
4. Evaluate each `khanelivim.profile` with `mkNixvimConfig`.
5. Serialize the curated profile data to JSON.
6. Render the JSON into `profiles.md`.
7. Build an mdBook site as `docs-html`.

## Commands

```bash
nix build .#docs-html
nix run .#docs
```

## Binary Cache

The build runs the `standard` profile headless to collect keymaps, so building
the docs locally needs the whole default package. CI builds `docs-html` on
`x86_64-linux` and `aarch64-darwin` and pushes it to the `khanelivim` Cachix
cache. Pull requests from forks are built but not pushed. On those two systems,
with the cache enabled, Nix substitutes the generated site for a pushed revision
instead of building the editor. On other systems, and for revisions CI has not
pushed, `nix run .#docs` still builds everything locally.

## Published Site

Every push to `main` deploys the `docs-html` output from the Linux CI build to
GitHub Pages at <https://khaneliman.github.io/khanelivim/>. The published site
always tracks `main`. For the docs of a pinned revision, use `nix run .#docs`
from that revision or install the `docs` package.

## Notes

- The option reference covers the `khanelivim.*` surface. It does not attempt to
  duplicate the entire upstream `plugins.*` universe from Nixvim.
- The profile matrix is intentionally curated. It documents the workflow surface
  you actually care about instead of dumping every option.
- `full` currently reflects the raw component defaults from the option modules.
- `debug` follows the full/default surface and layers debug-focused overrides on
  top.
