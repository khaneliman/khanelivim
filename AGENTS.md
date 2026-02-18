This file provides guidance to AI coding agents like Claude Code
(claude.ai/code), Cursor AI, Codex, Gemini CLI, GitHub Copilot, and other AI
coding assistants when working with code in this repository.

## Development Commands

- `nix run` or `just run` - Activate the configuration (run Neovim)
- `nix build` - Build the configuration
- `nix develop` or `just dev` - Enter development shell
- `nixvim-print-init` - Print the real generated `init.lua` for the active
  config (source of truth for runtime behavior)
- `nix fmt` or `just lint` - Format code (nixfmt, luacheck, biome)
- `nix flake check` or `just check` - Check Nix flake for issues
- `nix flake update` or `just update` - Update Nix flake dependencies
- `new-plugin <name> <template>` - Generate new plugin templates (available in
  dev shell)
- `deadnix -e` and `statix fix .` - Cleanup and fix Nix linting issues

## Generated Lua Source of Truth

- When debugging runtime behavior, always inspect `nixvim-print-init` output.
- Do not assume playground or ad-hoc configs (for example
  `~/.config/nvim/init.lua`) match the live generated setup.

## High-Level Code Architecture

This project is a modular Neovim configuration built using **Nixvim**.

- **`modules/nixvim/`**: The core Neovim configuration.
  - `plugins/`: Individual plugin configurations. Each plugin should ideally
    have its own directory.
  - `lsp/`: LSP server configurations and extensions.
  - `keymappings.nix`: Global keybindings.
  - `options.nix`: Standard Neovim options (vim.opt).
- **`modules/khanelivim/`**: High-level configuration options and profiles that
  wrap the Nixvim modules.
- **`packages/`**: Custom Nix packages for plugins or tools not available in
  nixpkgs.
- **`overlays/`**: Nix overlays for patching or overriding packages.
- **`flake.nix`**: The entry point for the Nix flake, defining outputs for
  packages and Neovim configurations.

## Code Style & Workflow

- **Nix**: Format with `nixfmt` (RFC style). Use `statix` and `deadnix`.
- **Lua**: Use `luacheck`.
- **JS/TS**: Use `biome`.
- **Modularity**: Follow the existing modular structure. When adding a new
  plugin, use the `new-plugin` script and ensure it's imported in the
  appropriate `default.nix`.
- **Lazy Loading**: Most plugins should be lazy-loaded using `lz.n`. Check
  existing plugin configs for the `lazyLoad` pattern.

## Performance Profiling

**CRITICAL**: Measure performance impact when adding/modifying plugins.

- `nix run .#profile -- -i --iterations 1` - Interactive profiling.
- `nix run .#profile -- -i --baseline --event deferred` - Save baseline.
- `nix run .#profile -- -i --compare --event deferred` - Compare against
  baseline.
- Target: Keep total deferred startup under 800ms. If a plugin adds >50ms, it
  MUST be lazy-loaded.

## Crash Debugging

If Neovim crashes:

- Check `coredumpctl list nvim` for segfaults.
- Use `PROF=1 nvim` to enable startup profiling.
- Common crash culprits: Dashboard + File Finder race conditions, LSP +
  Completion races.
- Fix by lazy-loading aggressive plugins or disabling debug modes that spawn
  excessive threads.
