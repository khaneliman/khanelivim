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

- `minimal` - rescue and smoke-test profile. Native UI/LSP with the smallest
  plugin surface. Use this when debugging breakage, testing native Neovim
  behavior, or working where startup cost and moving parts matter most.
- `basic` - comfortable remote editor. Native core plus treesitter, picker,
  statusline, key hints, file navigation, git signs, motion, and small editing
  comforts. Use this for SSH, containers, and daily-lite sessions.
- `standard` - conservative daily workstation. Current workflow-rich defaults
  stay intact because this is the khanelinix daily driver. Use this for normal
  development until standard pruning gets a dedicated pass.
- `full` - lab profile. Every optional and overlapping workflow remains enabled:
  alternate providers, experiments, account-backed tools, demos, and rarely used
  workflows. There is intentionally no `full` block in `profiles.nix`.
- `debug` - incident profile. `full` behavior with performance optimizations
  disabled and debug logging enabled.

See the `Profile Matrix` page for the evaluated differences between them.

## Plugin Posture

Profiles are meant to answer "why would I reach for this?", not only "how many
plugins are enabled?"

- Basic editor experience: treesitter, small `mini.*` editing helpers, comments,
  statusline, keybinding help, picker, file manager, motion, and git signs.
- Workflow layer: completion engine, formatter/linter orchestration, diagnostics
  browser, LSP navigation UI, project search, sessions, clipboard history, task
  runner, debugger, tests, and richer git/JJ tools.
- Specialized workstation layer: language-specific IDE plugins, refactoring,
  generated docs, framework helpers, and project-local environment integration.
- Fluff or visual nicety: dashboards, bufferline, animations, richer command UI,
  color previews, status decorations, screenshots, map views, and teaching
  overlays.
- Full-only experiments: duplicate providers, alternate AI clients, note
  systems, coding challenge tools, REPL integrations, browser integrations,
  broad test adapter sets, and rarely used markdown/documentation viewers.

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
