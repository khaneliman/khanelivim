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

## Notes

- The option reference covers the `khanelivim.*` surface. It does not attempt to
  duplicate the entire upstream `plugins.*` universe from Nixvim.
- The profile matrix is intentionally curated. It documents the workflow surface
  you actually care about instead of dumping every option.
- `full` currently reflects the raw component defaults from the option modules.
- `debug` follows the full/default surface and layers debug-focused overrides on
  top.
