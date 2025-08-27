# Contributing to Khanelivim

Thank you for your interest in contributing to Khanelivim! This document
provides guidelines for contributing to this Nixvim-based Neovim configuration.

## Code Style and Conventions

### Nix Code Style

1. **Formatting**: Use nixfmt for all Nix files
2. **Linting**: Use statix for Nix linting and deadnix to detect unused code
3. **Naming**: Follow existing naming conventions when adding new modules or
   plugins
4. **Organization**: Individual plugins should be configured in separate
   directories under `modules/nixvim/plugins/`

### Other Languages

- **Lua**: Use luacheck for Lua file validation
- **TypeScript/JavaScript**: Use biome for formatting
- **General**: Follow modular architecture in `modules/` for Neovim
  configuration

## Commit Message Convention

This repository follows a **component-based** commit message format:

```
component: description
```

### Examples:

- `conform: update deprecated setting`
- `treesitter: fix duplicate package`
- `kulala: fix duplicate package`
- `khanelivim: format`
- `flake.lock: update`

### Guidelines:

- Use lowercase for the description
- Use imperative mood ("fix", "add", "update", not "fixed", "added", "updated")
- No trailing period in the subject line
- Component should match the plugin name, module, or area being modified
- Keep the subject line concise and descriptive

## Development Workflow

### Prerequisites

- **Nix Package Manager**: Ensure Nix is installed on your system
- **Flakes enabled**: Make sure experimental features are enabled in your Nix
  configuration

### Available Commands

- `nix flake update` - Update Nix flake dependencies
- `nix flake check` - Validate the Nix flake configuration
- `nix develop` - Enter the development shell
- `nix run` - Activate the configuration for testing
- `nix build` - Build the configuration
- `new-plugin <plugin-name> <template-type>` - Generate new plugin templates
  (available in dev shell)
  - Template types:
    - `custom`: For plugins requiring custom Lua configuration or complex setup
    - `custom-lazy`: For plugins that need lazy loading with custom
      configuration
    - `nixvim`: For standard plugins that work well with native Nixvim options

### Making Changes

1. **Enter development shell**: `nix develop`
2. **Make your changes** in the appropriate module files
3. **Format and lint**:
   - Run `deadnix -e` to remove unused code
   - Run `statix fix .` to fix linting issues
   - Formatting is handled by pre-commit hooks
4. **Validate**: Run `nix flake check` to ensure configuration is valid
5. **Test**: Run `nix run` to test your changes

### Adding New Plugins

1. Create a new directory under `modules/nixvim/plugins/<plugin-name>/`
2. Choose the appropriate template type:
   - **`nixvim`**: Use for plugins with good Nixvim support and standard
     configuration needs (e.g., simple LSP servers, basic UI plugins)
   - **`custom`**: Use for plugins requiring complex Lua configuration, custom
     keymaps, or advanced setup (e.g., complex language tools, plugins with
     custom APIs)
   - **`custom-lazy`**: Use for plugins that benefit from lazy loading and have
     custom configuration requirements (e.g., heavy plugins, optional workflow
     tools)
3. Generate the template: `new-plugin <plugin-name> <template-type>`
4. Configure the plugin following the existing patterns
5. Add appropriate options to the khanelivim module system
6. Test the plugin works correctly
7. Update documentation if needed

#### Template Selection Guidelines

- **Start with `nixvim`** if the plugin has native Nixvim options and doesn't
  need complex setup
- **Choose `custom`** when you need to write significant Lua code or the plugin
  requires complex initialization
- **Use `custom-lazy`** for performance-critical scenarios where lazy loading is
  beneficial and custom configuration is needed

### Plugin Configuration Patterns

- **Modular approach**: Each plugin should have its own module
- **Conditional loading**: Use khanelivim options to conditionally enable
  plugins
- **Performance considerations**: Configure lazy loading where appropriate
- **Consistent options**: Follow the khanelivim.* option namespace

## Submitting Changes

1. **Create atomic commits**: Each commit should represent one logical change
2. **Follow commit message convention**: Use the component-based format
3. **Ensure quality**: Pre-commit hooks will run automatically
4. **Test thoroughly**: Verify your changes work with `nix run`
5. **Update documentation**: Update README.md or relevant docs if needed

## Plugin Categories

When adding plugins, place them in the appropriate category:

- **Completion & Snippets**: Blink, snippets engines
- **Language Support**: LSP, treesitter, formatters, linters
- **Navigation**: Telescope, FZF, file managers
- **Git Integration**: Gitsigns, diffview, git workflow tools
- **UI/UX**: Status lines, themes, notifications
- **Debugging & Testing**: DAP, neotest
- **AI & Productivity**: Copilot, Claude, Avante
- **Utilities**: General utility plugins

## Quality Standards

- All Nix code must pass `nix flake check`
- Follow the existing module structure and patterns
- Ensure plugins are properly configured for the target audience
- Test on multiple systems if possible
- Document any special requirements or configurations

## Getting Help

- Check the [CLAUDE.md](./CLAUDE.md) file for development guidance
- Review existing plugin configurations for patterns
- Use the development shell for access to helper commands
- Ensure you understand Nixvim configuration patterns before major changes

## Architecture

Khanelivim uses a modular architecture:

- **`flake.nix`**: Main flake configuration and outputs
- **`modules/khanelivim/`**: Core khanelivim module with options
- **`modules/nixvim/`**: Nixvim-specific configuration modules
- **`modules/nixvim/plugins/`**: Individual plugin configurations
- **`overlays/`**: Nix package overlays
- **`packages/`**: Custom packages and tools

Thank you for contributing to Khanelivim!
