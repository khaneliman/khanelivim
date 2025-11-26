# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Commands

- `nix flake update` - Update Nix flake
- `nix flake check` - Check Nix flake with `nix flake check`
- `nix develop` - Enter development shell
- `nix run` - Activate the configuration
- `nix build` - Build the configuration
- `new-plugin <plugin-name> <template-type>` - Generate new plugin templates
  (available in dev shell, template-type: custom, custom-lazy, nixvim)

## Code Style Guidelines

- Nix files: Format with nixfmt (RFC style)
- Use statix for Nix linting and deadnix to detect unused code
- Follow modular architecture in `modules/` for Neovim configuration
- Individual plugins should be configured in separate directories under
  `plugins/`
- Luacheck is used for Lua files
- For TypeScript/JavaScript use biome for formatting
- Follow existing naming conventions when adding new modules or plugins

## Development Workflow

- Make changes in appropriate module files
- Run `deadnix -e` and `statix fix .` before committing
- Verify changes with `nix flake check`
- Test by running `nix run` to activate the configuration

## Performance Profiling

**IMPORTANT**: When making changes to plugin configurations, lazy loading, or
adding new plugins, always measure the performance impact using these tools.

### Quick Commands

```bash
# Interactive mode (recommended - accurate timing, runs in terminal)
nix run .#profile -- -i --iterations 1

# Save baseline before making changes (per-event baselines)
nix run .#profile -- -i --iterations 1 --baseline --event ui
nix run .#profile -- -i --iterations 1 --baseline --event deferred

# Compare against baseline after changes (uses matching event baseline)
nix run .#profile -- -i --iterations 1 --compare --event ui
nix run .#profile -- -i --iterations 1 --compare --event deferred

# Profile different events
nix run .#profile -- -i --event ui        # UIEnter only (~230ms typical)
nix run .#profile -- -i --event deferred  # DeferredUIEnter (~650ms typical)
```

**Note**: Baselines are stored per event type. Use `--event ui` for initial
render timing and `--event deferred` for total startup including lazy-loaded
plugins.

### Profile Output Interpretation

The profiler shows time spent per plugin:

| Plugin     | Typical   | Notes                      |
| ---------- | --------- | -------------------------- |
| `core`     | 300-500ms | autocmds, vim internals    |
| `lz.n`     | 400-500ms | lazy loading orchestration |
| `snacks`   | 300-400ms | dashboard, utilities       |
| `gitsigns` | 200-400ms | git integration            |
| `lualine`  | 50-70ms   | statusline                 |

**Performance thresholds**:

- New plugin adding >50ms: Consider lazy loading
- Regression >5% on compare: Investigate or revert
- Total deferred >800ms: Review lazy load triggers

### When to Profile

**Always profile when**:

- Adding a new plugin
- Changing lazy loading configuration (lz.n triggers, events)
- Modifying plugin setup options
- Adding autocmds or keymaps that trigger plugin loads

**Workflow**:

1. Save baselines before making changes:
   - `nix run .#profile -- -i --iterations 1 --baseline --event ui`
   - `nix run .#profile -- -i --iterations 1 --baseline --event deferred`
2. Make changes
3. Compare against baselines:
   - `nix run .#profile -- -i --iterations 1 --compare --event ui`
   - `nix run .#profile -- -i --iterations 1 --compare --event deferred`
4. If regression >5%, optimize or reconsider the change

### Manual Profiling

```bash
# Quick startup profile (exports to ~/nvim-profile-*.md)
PROF=1 nvim -c ':ProfilerExport!' -c 'qa!'

# Profile with DeferredUIEnter (lz.n lazy loads)
PROF=1 PROF_EVENT=deferred nvim

# Auto-export JSON for automation
PROF=1 PROF_OUTPUT=/tmp/profile.json PROF_AUTO_QUIT=1 nvim
```

### Interactive Profiling (runtime)

- `<leader>up` - Toggle profiler on/off
- `<leader>uP` - Toggle profiler highlights (inline metrics)
- `<leader>ps` - Open profiler scratch buffer (adjust options)
- `:ProfilerExport` - Export to scratch buffer
- `:ProfilerExport!` - Export to auto-named file
- `:ProfilerExportJson!` - Export as JSON

### Profile Data Location

- Profiles stored in: `~/.cache/khanelivim/profiles/`
- Baselines (per event type):
  - `~/.cache/khanelivim/profiles/baseline-ui.json`
  - `~/.cache/khanelivim/profiles/baseline-deferred.json`
  - `~/.cache/khanelivim/profiles/baseline-lazy.json`

### Environment Variables

| Variable         | Description                          |
| ---------------- | ------------------------------------ |
| `PROF=1`         | Enable startup profiling             |
| `PROF_EVENT`     | Stop event: `ui`, `deferred`, `lazy` |
| `PROF_OUTPUT`    | Auto-export path                     |
| `PROF_FORMAT`    | Export format: `md`, `json`, `both`  |
| `PROF_AUTO_QUIT` | Exit after export (for automation)   |
