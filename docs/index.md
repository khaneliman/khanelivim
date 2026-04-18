# Khanelivim Docs

This site is built from the flake and the evaluated profile configuration.

The profile matrix is generated from `mkNixvimConfig`, so it tracks the
effective `khanelivim.profile` behavior instead of hand-maintained README prose.

## Commands

```bash
nix build .#docs-html
nix run .#docs
```

## Included Pages

- `Using the Flake` explains the supported ways to run the default package,
  install it from Home Manager, or build a customized package through the flake
  `lib` helpers.
- `Customizing Khanelivim` explains the intended override layers:
  `khanelivim.*`, then `plugins.*`, then `extraConfigLua`.
- `Development Workflow` documents the repo-facing shell, checks, plugin
  generator, docs build, and profiling commands.
- `Keymaps` groups runtime-discovered mappings into UX-oriented pages like
  navigation, search, git, LSP, toggles, and language workflows.
- `Language Tooling Workflows` explains the generic `<leader>l` and
  language-specific `<leader>z` runtime model, plus the workspace-aware web
  tooling ownership rules.
- `Selecting Profiles` explains how the flake default is chosen and how to build
  a non-default profile.
- `Options Reference` documents the `khanelivim.*` option surface from the
  evaluated module tree.
- `Profile Matrix` shows the evaluated enablement for each profile.
- `Docs Pipeline` explains how the generated site is built.
