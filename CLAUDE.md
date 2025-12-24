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

## Git Commit Conventions

This project uses a **scope-based commit format**, NOT conventional commits.

### Format

```
scope: description
```

- **Scope**: The module, component, or file being changed
- **Description**: Lowercase verb phrase describing the change
- **NO type prefix** (no `feat:`, `fix:`, `perf:`, etc.)

### Examples

**Plugin changes:**

```
copilot-lsp: add lazy loading on InsertEnter
fff: disable debug mode and add lazy loading to prevent crashes
lualine: use package.loaded for sidekick status
```

**Module/options changes:**

```
nixvim/options: refactor and cleanup
options/ui: add zenMode option
options/profiles: init module
```

**Build/infrastructure:**

```
flake.lock: update vimplugins
flake.lock: update
.github: Bump DeterminateSystems/update-flake-lock from 27 to 28
overlays/input-packages: skip checks for fzf,grug,neotest
```

**Documentation/performance:**

```
docs: add crash debugging and troubleshooting guide
docs: update profiling docs for per-event baselines
performance: add disabled plugins
```

**Apps/scripts:**

```
apps/profile: more runs on baseline
apps/profile: support profile baselines and compares
apps/profile: use event-specific baselines
```

### Common Scopes

- Plugin name: `copilot-lsp`, `fff`, `lualine`, etc.
- Module path: `nixvim/options`, `options/ui`, `overlays/input-packages`
- Special scopes: `docs`, `performance`, `flake.lock`, `.github`

### Action Verbs

- `add` - New feature, module, or functionality
- `update` - Update existing code or dependencies
- `remove` - Delete code or features
- `fix` - Bug fixes
- `refactor` - Code restructuring without behavior change
- `disable` - Turn off a feature
- `enable` - Turn on a feature
- `init` - Initialize new module or component

### Multi-line Commits

For complex changes, use a blank line after the subject, then add details:

```
scope: brief description

- Detail about change 1
- Detail about change 2
- Rationale or context
```

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

## Crash Debugging & Troubleshooting

When Neovim crashes (segfaults, freezes, or unexpected behavior), follow this
systematic debugging approach.

### Step 1: Check for Crash Logs

Neovim and system logs can provide immediate insight into crashes:

```bash
# Check for core dumps (most useful for segfaults)
coredumpctl list nvim

# View most recent crash details
coredumpctl info $(coredumpctl list nvim | tail -1 | awk '{print $5}')

# Get stack trace from most recent crash
coredumpctl debug $(coredumpctl list nvim | tail -1 | awk '{print $5}') \
  --debugger-arguments="-batch -ex 'bt' -ex 'quit'"

# Check Neovim state logs
ls -lth ~/.local/state/nvim/*.log | head -5

# Check kernel logs for segfaults
dmesg | grep -i segfault | grep nvim | tail -10

# Check systemd journal
journalctl --user | grep -i nvim | tail -20
```

### Step 2: Analyze Stack Traces

When examining a coredump stack trace, look for these key indicators:

**Main thread crash patterns:**

```
#0  multiqueue_put_event    <- Event queue corruption
#1  emit_termrequest         <- Terminal I/O race condition
#2  state_handle_k_event     <- Keyboard event handling
#3  normal_execute           <- Normal mode execution
```

**Common crash locations and meanings:**

| Function                | Likely Cause                                    |
| ----------------------- | ----------------------------------------------- |
| `multiqueue_put_event`  | Race condition between threads/event loops      |
| `emit_termrequest`      | Terminal request/response timing issue          |
| `lua_*` functions       | Lua plugin crash, check loaded modules          |
| `tree_sitter_*`         | Treesitter parser issue, check language parsers |
| Background thread crash | Plugin with threading (fff, etc.)               |

**Background threads in stack trace:**

Multiple worker threads (rayon, inotify, crossbeam) indicate:

- Plugin with heavy parallelism (fff, etc.)
- File watching/indexing operations
- Potential race conditions with main thread

### Step 3: Identify the Culprit Plugin

**Check loaded modules in coredump:**

```bash
# Look for plugin-specific shared libraries in crash info
coredumpctl info <pid> | grep -i "Module.*\.so"
```

Common indicators:

- `libfff_nvim.so` - fff file finder
- `libtree-sitter.so` - Treesitter parsers
- Custom `.so` files - Binary plugins

**Correlate with your configuration:**

1. Note which plugins were recently added/modified
2. Check if plugins have `debug` or `verbose` modes enabled
3. Identify plugins that are NOT lazy-loaded (immediate startup)
4. Look for plugins with background workers or file watchers

### Step 4: Common Race Conditions

**Dashboard + File Finder Crash:**

- **Symptom:** Crash when quickly opening file from dashboard
- **Cause:** Dashboard terminal sections + eager-loaded file finder
- **Solution:** Lazy-load file finder, disable debug modes

**LSP + Completion Crash:**

- **Symptom:** Crash when typing quickly or on completion
- **Cause:** Multiple LSP clients + completion plugin race
- **Solution:** Ensure single LSP client per filetype, lazy-load completion

**Treesitter + Fold Crash:**

- **Symptom:** Crash when opening/editing large files
- **Cause:** Treesitter parsing + fold calculation simultaneously
- **Solution:** Disable folds for large files, lazy-load fold plugins

### Step 5: Debugging Workflow

**Reproduce the crash:**

```bash
# Run with verbose logging
nvim --startuptime startup.log -V9startup_verbose.log

# Run with minimal config to isolate issue
nvim -u NONE  # Completely clean
nvim -u minimal.lua  # Your minimal config
```

**Binary search for culprit:**

1. Disable half your plugins
2. Test if crash still occurs
3. Re-enable/disable half of remaining suspects
4. Repeat until single plugin identified

**Quick checks:**

```bash
# Check for plugins with debug modes enabled
rg "debug.*enabled.*true" modules/nixvim/plugins/

# Check for plugins without lazy loading
rg "plugins\.\w+\s*=\s*{" modules/nixvim/plugins/ | \
  xargs -I {} sh -c 'grep -L "lazyLoad" {}'

# Find plugins with heavy background operations
rg -i "worker|thread|async|background" modules/nixvim/plugins/
```

### Step 6: Fixing Race Conditions

**General solutions:**

1. **Lazy load aggressive plugins:**
   ```nix
   lazyLoad.settings = {
     cmd = [ "PluginCommand" ];
     keys = [ "<leader>key" ];
   };
   ```

2. **Disable debug modes:**
   ```nix
   debug.enabled = false;  # Reduces thread overhead
   ```

3. **Sequence plugin loading:**
   - Dashboard should load first (before file operations)
   - File finders should lazy load on keymap
   - LSP should wait for FileType events

4. **Reduce parallelism:**
   - Limit worker threads in plugin configs
   - Disable background file watchers if unnecessary
   - Use synchronous operations for critical paths

### Step 7: Document Your Fix

Always add comments explaining race condition fixes:

```nix
# Debug mode disabled to prevent race condition crashes when quickly opening
# files from dashboard. Debug mode spawns ~20 background threads that conflict
# with terminal request/response system causing segfaults in multiqueue_put_event.
debug.enabled = false;
```

This helps future you (and others) understand why seemingly useful features are
disabled.
