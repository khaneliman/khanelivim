# Selecting Profiles

Khanelivim exposes multiple presets through the `khanelivim.profile` module
option.

The default flake package is a separate layer from that module option. `nix run`
and `nix build` use the package built from `mkNixvimConfig`, and that function
currently defaults to the `standard` profile.

## What This Means

- `nix run` and `nix build` use the default flake package, which currently
  evaluates the `standard` profile.
- Changing the option default in `modules/khanelivim/options/profiles.nix`
  changes the module fallback, but it does not change the flake's default
  package by itself.
- To select a different profile, build or evaluate through
  `khanelivim.lib.mkNixvimPackage` or `khanelivim.lib.mkNixvimConfig` and pass
  `profile = "..."`.

Available profiles:

- `minimal`
- `basic`
- `standard`
- `full`
- `debug`

See the `Profile Matrix` page for the evaluated differences between them.

## Local Example

Build and run the `debug` profile from a local checkout:

```bash
nix build --impure --expr '
let
  f = builtins.getFlake (toString ./.);
in
  f.lib.mkNixvimPackage {
    system = builtins.currentSystem;
    profile = "debug";
  }'
./result/bin/nvim
```

## Home Manager Example

Use a specific profile when adding khanelivim to `home.packages`:

```nix
{
  home.packages = [
    (let
      debugConfig = khanelivim.lib.mkNixvimConfig {
        system = pkgs.system;
        profile = "debug";
      };
    in
      debugConfig.config.build.package)
  ];
}
```
