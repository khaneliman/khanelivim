For any Nix code or module task, use the `writing-nix` skill before making
edits.

## Generated Lua Source of Truth

- When debugging runtime behavior, always inspect `nixvim-print-init` output.
- Do not assume playground or ad-hoc configs (for example
  `~/.config/nvim/init.lua`) match the live generated setup.

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
