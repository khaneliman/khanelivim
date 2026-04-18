# Development Workflow

This page is for working on the Khanelivim repo itself, not for consuming the
built package.

## Development Shell

Enter the dev shell before doing repo work:

```bash
nix develop
```

That gives you the formatting, linting, and helper tools used by the repo.

## Core Commands

```bash
# Update flake inputs
nix flake update

# Validate the flake
nix flake check

# Format and lint Nix code
nix fmt
deadnix -e
statix fix .

# Build the default package
nix build

# Run the default package
nix run
```

## Adding A Plugin

Use the plugin generator from the dev shell:

```bash
new-plugin <plugin-name> <template-type>
```

Template choices:

- `nixvim` for standard plugins that map cleanly to upstream Nixvim options
- `custom` for plugins that need custom Lua or more complex setup
- `custom-lazy` for plugins that should be lazy-loaded and need custom setup

After generating the module:

1. configure the plugin in its module
2. prefer `khanelivim.*` option wiring when exposing user-facing behavior
3. test the result with `nix build` or `nix run`

## Editing Existing Behavior

When changing the repo itself:

- keep edits modular
- prefer semantic `khanelivim.*` options over one-off plugin hacks
- use the generated init as the runtime source of truth when debugging behavior

If you are debugging Neovim runtime behavior, inspect `nixvim-print-init` output
rather than assuming a local ad-hoc config matches the built package.

## Docs

The docs are generated from the evaluated flake outputs:

```bash
nix build .#docs-html
nix run .#docs
```

Use the generated docs for:

- `khanelivim.*` options
- evaluated profile differences
- usage workflows and customization guidance

## Performance

When adding or changing plugins, measure startup impact:

```bash
nix run .#profile -- -i --iterations 1
nix run .#profile -- -i --baseline --event deferred
nix run .#profile -- -i --compare --event deferred
```

The current target is to keep deferred startup under roughly `800ms`, and new
plugins that add meaningful startup cost should usually be lazy-loaded.

## Contribution Notes

For repository conventions, read:

- `CONTRIBUTING.md` for style, workflow, and commit guidance
- `AGENTS.md` for repo-specific development rules used during automated edits
