# Khanelivim: My Nix-Powered Neovim Configuration

This is my fully customized Neovim configuration, built with Nix and the
powerful [Nixvim flake](https://github.com/nix-community/nixvim). Enjoy a
consistent, reproducible, and easy-to-manage Neovim environment across different
machines.

![Screenshot](assets/screenshot.png)

## Key Features

- **Nixvim for Declarative Configuration:** Leverage Nix expressions for a clean
  and maintainable Neovim setup with 100+ carefully configured plugins.
- **AI-Powered Development:** Integrated GitHub Copilot, Claude Code, Avante,
  and Blink completion for intelligent coding assistance.
- **Modern Plugin Architecture:** Modular plugin system with lazy loading and
  comprehensive language support for 20+ programming languages.
- **Advanced Navigation:** Multiple fuzzy finders (Telescope, FZF-Lua, Snacks
  Picker), file managers (Yazi, Neo-tree), and movement plugins (Flash, Hop).
- **Comprehensive Git Integration:** Full Git workflow support with Gitsigns,
  Diffview, Git Conflict resolution, and worktree management.
- **Debugging & Testing:** Complete debugging setup with DAP and comprehensive
  testing with Neotest for multiple languages.
- **Consistent Environments:** Reproduce your Neovim setup effortlessly on any
  system with Nix installed.

## Prerequisites

- **Nix Package Manager:** Ensure Nix is installed on your system. Follow the
  instructions at
  [https://nixos.org/download.html](https://nixos.org/download.html).

## Installation

**Option 1: Using `nix run` (Easiest):**

```bash
nix run --extra-experimental-features 'nix-command flakes' github:khaneliman/khanelivim
```

**Option 2: Build and run locally:**

```bash
git clone https://github.com/khaneliman/khanelivim.git
cd khanelivim
nix run
```

**Option 3: Home Manager Integration:**

Add to your Home Manager configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    khanelivim.url = "github:khaneliman/khanelivim";
  };

  outputs = { nixpkgs, home-manager, khanelivim, ... }: {
    homeConfigurations.username = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        {
          home.packages = [
            # Option A: Use default configuration
            khanelivim.packages.x86_64-linux.default

            # Option B: Extend with customizations
            (let
              baseConfig = khanelivim.nixvimConfigurations.x86_64-linux.khanelivim;
              extendedConfig = baseConfig.extendModules {
                modules = [
                  {
                    # Disable specific plugins
                    plugins.yazi.enable = false;

                    # Override plugin settings
                    plugins.lualine.settings.options.theme = "gruvbox";

                    # Add custom Lua configuration
                    extraConfigLua = ''
                      vim.opt.relativenumber = false
                    '';
                  }
                ];
              };
            in extendedConfig.config.build.package)
          ];
        }
      ];
    };
  };
}
```

## Development Commands

```bash
# Update flake dependencies
nix flake update

# Check flake for issues
nix flake check

# Format/lint code
nix fmt
deadnix -e
statix fix .

# Enter development shell
nix develop

# Run Neovim
nix run
```

### Development Workflow

1. **Add new plugins:** Use the `new-plugin` script in dev shell:
   ```bash
   nix develop
   new-plugin <plugin-name> <template-type>
   ```

2. **Format and check:** Always run before committing:
   ```bash
   nix fmt
   deadnix -e
   statix fix .
   ```

3. **Testing changes:** Build and test locally:
   ```bash
   nix build && ./result/bin/nvim
   ```

## Plugins (100+)

### **AI & Code Intelligence**

- **avante** - AI-powered code assistant with chat interface
- **blink** - Modern completion engine with multiple sources
- **copilot** - GitHub Copilot integration with chat
- **claude-code** - Claude AI assistant integration

### **UI/UX & Interface**

- **catppuccin** - Macchiato colorscheme with comprehensive theming
- **bufferline** - Enhanced buffer/tab line with custom styling
- **lualine** - Highly customizable status line
- **which-key** - Keybinding popup help system
- **noice** - Enhanced UI for messages, cmdline, and popups
- **snacks** - Dashboard, picker, and various UI utilities
- **indent-blankline** - Indentation guides
- **statuscol** - Enhanced status column

### **Navigation & Movement**

- **flash** - Enhanced navigation with jump labels
- **hop** - EasyMotion-like navigation
- **harpoon** - Quick file navigation and bookmarking
- **telescope** - Fuzzy finder with extensions (file-browser, frecency,
  fzf-native, etc.)
- **fzf-lua** - Alternative fuzzy finder with git/LSP integration
- **yazi** - Terminal file manager integration
- **neo-tree** - File explorer sidebar (when yazi disabled)

### **Git Integration**

- **gitsigns** - Git decorations with blame, hunks, and staging
- **diffview** - Enhanced diff viewing
- **git-conflict** - Git conflict resolution utilities
- **git-worktree** - Git worktree management
- **gitignore** - Gitignore file generation

### **Language Support & LSP**

- **lspconfig** - LSP client configurations for 20+ languages
- **rustaceanvim** - Comprehensive Rust development
- **typescript-tools** - Enhanced TypeScript/JavaScript support
- **jdtls** - Java language server
- **clangd-extensions** - C/C++ enhancements
- **easy-dotnet** - .NET development tools
- **nix** - Nix language support
- **lazydev** - Lua development enhancements

### **Code Formatting & Linting**

- **conform** - Code formatting (prettier, biome, stylua, etc.)
- **lint** - Linting (shellcheck, eslint, clippy, etc.)
- **ts-comments** - TypeScript/JavaScript comment utilities

### **Debugging & Testing**

- **dap** - Debug Adapter Protocol with multi-language support
- **dap-ui** - Debug UI interface
- **dap-virtual-text** - Virtual text during debugging
- **neotest** - Testing framework with multiple adapters

### **Code Editing & Manipulation**

- **treesitter** - Syntax highlighting and code parsing
- **mini** - Collection of mini modules (ai, align, comment, surround, etc.)
- **luasnip** - Snippet engine with friendly-snippets
- **refactoring** - Code refactoring utilities
- **neogen** - Documentation generation
- **multicursor** - Multiple cursor support
- **yanky** - Enhanced yank/paste functionality

### **Productivity & Workflow**

- **persistence** - Session management
- **wakatime** - Time tracking
- **toggleterm** - Terminal integration
- **overseer** - Task runner
- **rest** - REST client for API testing
- **grug-far** - Find and replace across files

### **Documentation & Writing**

- **markdown-preview** / **markview** - Markdown preview and rendering
- **glow** - Terminal markdown rendering
- **neorg** - Note-taking and organization
- **devdocs** - Documentation browser

### **Visual Enhancements**

- **illuminate** - Highlight word under cursor
- **colorizer** / **ccc** - Color code highlighting and picker
- **smartcolumn** - Smart column guides
- **trouble** - Diagnostics and quickfix list
- **todo-comments** - TODO comment highlighting

_See `modules/nixvim/plugins/` for complete plugin configurations._

## LSP (Language Server Protocol) Configuration

This configuration emphasizes LSP support to enhance your coding experience with
features like:

- Diagnostics: Visual feedback for errors, warnings, hints, and information
  using symbols (e.g., ❌ for errors).
- Navigation: Quickly jump to definitions, references, implementations, and type
  definitions.
- Code Actions: Access context-aware suggestions for code improvements.
- Hover Information: Get detailed information about symbols by hovering over
  them.
- Rename: Refactor symbols accurately across your codebase.
- Formatting: Automatically format your code (either through a dedicated
  formatter or LSP capabilities).

### Key LSP Plugins:

- **lspconfig** - Core LSP client configurations
- **glance** - Preview definitions/references in floating windows
- **lightbulb** - Visual indicators for available code actions
- **navic** - LSP-based breadcrumb navigation
- **trouble** - Enhanced diagnostics and quickfix lists
- **rustaceanvim** - Advanced Rust development with rust-analyzer
- **typescript-tools** - Enhanced TypeScript/JavaScript support
- **jdtls** - Dedicated Java language server integration
- **clangd-extensions** - C/C++ specific enhancements
- **easy-dotnet** - .NET development utilities

### LSP Servers:

The configuration includes a comprehensive list of LSP servers to support
various programming languages, including:

- **Bash/Shell** - bashls
- **C/C++** - ccls, clangd with extensions
- **C#/.NET** - roslyn, csharp-ls
- **CSS/SCSS/Less** - cssls
- **Docker** - dockerls
- **Go** - gopls
- **HTML** - html
- **Java** - jdtls (dedicated plugin)
- **JavaScript/TypeScript** - typescript-tools, eslint
- **JSON** - jsonls
- **Lua** - lua-ls with lazydev
- **Markdown** - marksman, harper-ls
- **Nix** - nil-ls, nixd
- **Python** - pyright
- **Rust** - rust-analyzer (via rustaceanvim)
- **SQL** - sqls
- **TOML** - taplo
- **YAML** - yamlls
- **Helm** - helm-ls
- **Typos** - typos-lsp

Each server has specific settings tailored to its language, such as filetype
associations, initialization options, and formatting configurations.

### LSP Keymappings:

The configuration defines key mappings for common LSP actions:

- **Code Navigation:**
  - `gd` - Go to definition
  - `gD` - Go to declaration
  - `gi` - Go to implementation
  - `gt` / `gy` - Go to type definition
  - `gr` - Find references
  - `K` - Hover documentation

- **Code Actions:**
  - `<leader>ca` - Code actions
  - `<leader>rn` - Rename symbol
  - `<leader>f` - Format code

- **Diagnostics:**
  - `]d` / `[d` - Next/previous diagnostic
  - `<leader>e` - Show line diagnostics
  - `<leader>q` - Open diagnostics list

### Additional Features:

- **Automatic formatting** via conform.nvim with language-specific formatters
- **Linting integration** with various linters through nvim-lint
- **Code completion** powered by Blink with LSP, Copilot, and snippet sources
- **Debugging support** via DAP with UI and virtual text
- **Testing integration** through Neotest with multiple language adapters
- **Project-wide search** and refactoring tools (Spectre, Grug-far,
  Refactoring.nvim)

## Key Mappings

### Essential Navigation

| Key       | Action         | Description                    |
| --------- | -------------- | ------------------------------ |
| `<Space>` | Leader key     | Primary prefix for custom maps |
| `<Esc>`   | Clear search   | Clear search highlighting      |
| `<C-c>`   | Switch buffer  | Toggle between recent buffers  |
| `j/k`     | Smart movement | Visual line aware movement     |
| `Y`       | Yank to end    | Yank to end of line            |

### Window & Buffer Management

| Key               | Action            | Description          |
| ----------------- | ----------------- | -------------------- |
| `<TAB>`           | Next buffer       | Navigate buffers     |
| `<S-TAB>`         | Previous buffer   | Navigate buffers     |
| `\|`              | Vertical split    | Split window         |
| `-`               | Horizontal split  | Split window         |
| `<leader>[/]/,/.` | Window nav        | Move between windows |
| `<leader>w`       | Save file         | Write current buffer |
| `<leader>q`       | Quit with confirm | Safe quit            |
| `<C-w>`           | Close buffer      | Smart buffer close   |

### File Finding & Search

| Key               | Action            | Description              |
| ----------------- | ----------------- | ------------------------ |
| `<leader><space>` | Smart find files  | Main file finder         |
| `<leader>ff`      | Find files        | Standard file finder     |
| `<leader>fo`      | Recent files      | Recently opened files    |
| `<leader>fb`      | Find buffers      | List open buffers        |
| `<leader>fw`      | Live grep         | Search in files          |
| `<leader>f/`      | Buffer fuzzy find | Search in current buffer |
| `<leader>fh`      | Find help         | Search help tags         |
| `<leader>fk`      | Find keymaps      | Search keybindings       |
| `<leader>fc`      | Find commands     | Search commands          |

### File Management

| Key          | Action        | Description            |
| ------------ | ------------- | ---------------------- |
| `<leader>e`  | File explorer | Open Yazi file manager |
| `<leader>E`  | File explorer | Toggle Neo-tree/Yazi   |
| `<leader>fe` | File explorer | Snacks file explorer   |

### Git Integration

| Key               | Action         | Description            |
| ----------------- | -------------- | ---------------------- |
| `<leader>gg`      | Lazygit        | Open Lazygit interface |
| `<leader>gs`      | Git status     | Find git status        |
| `<leader>gC`      | Git commits    | Browse commits         |
| `<leader>gb`      | Git blame      | Toggle git blame       |
| `<leader>gd`      | Git diff hunks | Show git diff hunks    |
| `<leader>ghn/p`   | Hunk nav       | Next/previous git hunk |
| `<leader>ghs/u/r` | Hunk ops       | Stage/undo/reset hunk  |

### Code Navigation (LSP)

| Key          | Action               | Description             |
| ------------ | -------------------- | ----------------------- |
| `gd`         | Go to definition     | Jump to definition      |
| `grr`        | Find references      | Show all references     |
| `gri`        | Go to implementation | Jump to implementation  |
| `gy`         | Go to type def       | Jump to type definition |
| `K`          | Hover docs           | Show documentation      |
| `<leader>la` | Code actions         | Show code actions       |

### Diagnostics & Debugging

| Key              | Action           | Description             |
| ---------------- | ---------------- | ----------------------- |
| `<leader>xx`     | Diagnostics      | Toggle diagnostics list |
| `<leader>fd`     | Find diagnostics | Buffer diagnostics      |
| `<leader>fD`     | Find diagnostics | Workspace diagnostics   |
| `<leader>db`     | Debug breakpoint | Toggle breakpoint       |
| `<leader>dc`     | Debug continue   | Start/continue debug    |
| `<leader>di/o/O` | Debug step       | Step into/out/over      |

### Quick Navigation

| Key          | Action           | Description            |
| ------------ | ---------------- | ---------------------- |
| `s`          | Flash jump       | Quick jump to location |
| `S`          | Flash treesitter | Treesitter-aware jump  |
| `<leader>ha` | Harpoon add      | Add file to harpoon    |
| `<leader>he` | Harpoon menu     | Quick harpoon menu     |

### Toggle Options

| Key          | Action             | Description        |
| ------------ | ------------------ | ------------------ |
| `<leader>ud` | Toggle diagnostics | Buffer diagnostics |
| `<leader>uf` | Toggle formatting  | Auto-formatting    |
| `<leader>uw` | Toggle word wrap   | Text wrapping      |
| `<leader>uS` | Toggle spell check | Spell checking     |
| `<leader>uT` | Toggle terminal    | Terminal interface |

### Utility

| Key          | Action          | Description             |
| ------------ | --------------- | ----------------------- |
| `<leader>fy` | Yank history    | Paste from yank history |
| `<leader>f'` | Find marks      | Search marks            |
| `<leader>ft` | Find TODOs      | Search TODO comments    |
| `<leader>:`  | Command history | Recent command history  |

_Note: Use `<leader>` (Space) and wait to see all available options via
which-key. Many plugins provide additional context-specific keybindings._

## Architecture

The configuration follows a modular architecture:

```
modules/nixvim/
├── plugins/          # Individual plugin configurations
│   ├── telescope/    # Fuzzy finder setup
│   ├── lsp/         # Lspconfig configuration
│   ├── dap/         # Debugging setup
│   └── ...
├── keymappings.nix   # Global key mappings
├── options.nix       # Neovim options
├── lsp.nix          # LSP configurations
└── default.nix      # Main module entry point
```

## Customization

### Development Customization

For local development and contribution:

#### Adding New Plugins

1. Enter the development shell: `nix develop`
2. Use the plugin generator: `new-plugin <name> <template-type>`
   - Templates: `custom`, `custom-lazy`, `nixvim`
3. Configure the plugin in its `default.nix`
4. Import it in the main plugins configuration

#### Modifying Existing Plugins

Each plugin has its own directory with configuration. Edit the `default.nix`
file in the respective plugin directory.

#### Language Support

Add new language servers in `modules/nixvim/lsp/` and formatters/linters in the
respective plugin configurations.

### Development Setup

```bash
git clone https://github.com/khaneliman/khanelivim.git
cd khanelivim
nix develop
```
