# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Commands

- `nix flake update` - Update Nix flake
- `nix flake check` - Check Nix flake with `nix flake check`
- `nix develop` - Enter development shell
- `nix run` - Activate the configuration
- `nix build` - Build the configuration
- `new-plugin <plugin-name> <template-type>` - Generate new plugin templates (available in dev shell, template-type: custom, custom-lazy, nixvim)

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
