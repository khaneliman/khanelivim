# Khanelivim: My Nix-Powered Neovim Configuration

This is my fully customized Neovim configuration, built with Nix and the
powerful [Nixvim flake](https://github.com/nix-community/nixvim). Enjoy a
consistent, reproducible, and easy-to-manage Neovim environment across different
machines.

![Screenshot of your Neovim setup] (optional)

## Key Features

- **Nixvim for Declarative Configuration:** Leverage Nix expressions for a clean
  and maintainable Neovim setup. Easily add, remove, or update plugins, LSP
  servers, and other components.
- **Consistent Environments:** Reproduce your Neovim setup effortlessly on any
  system with Nix installed.
- **Plugin Management:** Seamlessly manage plugins using Nixvim's declarative
  configuration.
- **LSP Integration:** Built-in support for language servers and completion
  tools.
- **Customization:** Adapt to your preferences with additional plugins, themes,
  and key mappings (details below).

## Prerequisites

- **Nix Package Manager:** Ensure Nix is installed on your system. Follow the
  instructions at
  [https://nixos.org/download.html](https://nixos.org/download.html).

## Installation

**Option 1: Using `nix run` (Easiest):**

```bash
nix run github:khaneliman/khanelivim
```

**Option 2: Adding as a Flake Input:**

In your system's Nix configuration (e.g., ~/.config/nixpkgs/flake.nix or
~/.config/nixpkgs/home.nix), add the following:

```nix
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Or your preferred channel
      khanelivim.url = "github:khaneliman/khanelivim";
    };

    outputs = { self, nixpkgs, khanelivim }: {
      # ... your other configuration ...

      # Add to your system packages or devShell if you want to make it available system-wide
      packages = with nixpkgs; [
        khanelivim.packages.${system}.default
      ];

      # Or, use in a devShell:
      devShells.default = nixpkgs.mkShell {
        nativeBuildInputs = [ khanelivim.packages.${system}.default ];
      };
    };
```

**Option 3: Build and run locally:**

```bash
nix build . && ./result/bin/nvim
```

## Configuration Highlights

    Plugins:
        [List your key plugins here with a brief description of their purpose]
    LSP Servers:
        [List the languages you have LSP support for]
    Theme:
        [Name your theme]
    Key Mappings:
        [Describe any important custom key mappings]

For the full configuration details, please explore the flake.nix file in the
repository. Usage

Simply run nvim from your terminal.

### Updating

```bash
nix flake update
```

### Rebuild your Neovim:

```bash
nix build
```

### Run the updated Neovim:

```bash
./result/bin/nvim
```

## Customization / Contributing

Feel free to fork the repository and modify the flake.nix file to personalize
your Neovim configuration. Contributing

Pull requests are welcome! If you'd like to make improvements, please open an
issue or submit a PR.

### Enter Nix Shell:

```bash
cd ~/.config/nvim nix develop
```

*(If you have direnv installed, it should automatically activate the environment
when you cd into the directory.)
