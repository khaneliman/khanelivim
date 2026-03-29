# Language Tooling Workflows

Khanelivim splits editing workflows into two namespaces:

- `<leader>l` for generic LSP and diagnostics actions
- `<leader>z` for language-specific tooling in the current buffer

## Generic LSP Workflow

Common actions live under `<leader>l`:

- `<leader>lT` shows `:ToolingInfo` for the current buffer
- `<leader>lI` runs `:checkhealth vim.lsp`
- `<leader>lX` runs `:lsp restart`
- `<leader>l[` / `<leader>l]` jump between diagnostics
- `<leader>lH` opens the diagnostic float
- `<leader>la`, `<leader>lr`, `<leader>ld`, `<leader>li`, `<leader>lt` cover the
  usual code-action, rename, definition, implementation, and type-definition
  flow
- `<leader>lq`, `<leader>le`, `<leader>lE`, `<leader>lW`, and `<leader>lQ`
  surface diagnostics in loclists, quickfix, or workspace requests

Neovim's built-in motions are still available too, such as `gd`, `grr`, `gri`,
`K`, and `gx`.

## Language Namespaces

Language-specific actions live under `<leader>z` and are buffer-local.

Examples:

- TypeScript: organize imports, fix all, add missing imports, source definition,
  tsserver logs
- Rust: runnables, debuggables, crate graph, cargo, rust-analyzer logs, macro
  expansion
- Python: virtual environment selection, cached env activation, venv logs,
  nearest/file/last test, DAP-backed test debugging
- .NET: build, run, debug, test runner, watch, diagnostics, outdated packages

This keeps the `<leader>l` group stable across languages while still making
language-specific power features easy to reach.

## Workspace Tool Ownership

Web tooling is workspace-aware:

- Formatting owner:
  - `biome.json` / `biome.jsonc` / `package.json#biomejs` -> Biome
  - Prettier config / `package.json#prettier` -> Prettier
  - otherwise -> fallback order, currently `biome` then `prettierd` for JS/TS
- Diagnostics owner:
  - Biome config -> Biome
  - ESLint config / `package.json#eslintConfig` -> ESLint
  - otherwise -> no explicit JS/TS diagnostics owner

Use `:WebToolingInfo` to inspect the current workspace's detected formatter and
diagnostics owners.

## Inspectors and Toggles

Use these when troubleshooting editor behavior:

- `:ToolingInfo` or `<leader>lT` for current buffer roots, clients, diagnostic
  state, and formatter details
- `:WebToolingInfo` for web-specific tool ownership
- `<leader>ueI` to toggle diagnostics while typing
- `<leader>uev` to toggle diagnostic virtual lines
- `<leader>ueC` to toggle code lens
- `<leader>uec` to toggle document colors
- `<leader>ueS` to toggle semantic tokens
