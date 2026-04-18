# Using the Flake

Khanelivim supports three main ways of working with the config.

## 1. Run The Default Package

This is the fastest way to try it. The default package currently builds the
`standard` profile.

```bash
nix run github:khaneliman/khanelivim
```

From a local checkout:

```bash
nix run
```

## 2. Install It From Home Manager

The supported Home Manager workflow is to install the built Neovim package via
`home.packages`.

```nix
{
  home.packages = [
    khanelivim.packages.${pkgs.system}.default
  ];
}
```

This repo does not expose a dedicated Home Manager module for configuration. Use
the package or build a customized package through the flake `lib` helpers.

## 3. Build A Customized Config

Use `khanelivim.lib.mkNixvimConfig` when you want an evaluated config you can
extend with modules, or `khanelivim.lib.mkNixvimPackage` when you only need the
final package.

Pick a non-default profile directly:

```nix
let
  debugConfig = khanelivim.lib.mkNixvimConfig {
    system = pkgs.system;
    profile = "debug";
  };
in
  debugConfig.config.build.package
```

Extend a base profile with your own overrides:

```nix
let
  customConfig = (khanelivim.lib.mkNixvimConfig {
    system = pkgs.system;
    profile = "minimal";
  }).extendModules {
    modules = [
      {
        khanelivim.editor.fileManager = "yazi";
        khanelivim.ui.keybindingHelp = "which-key";
        extraConfigLua = ''
          vim.opt.relativenumber = false
        '';
      }
    ];
  };
in
  customConfig.config.build.package
```

Prefer the high-level `khanelivim.*` options when possible. Drop to `plugins.*`
or raw Lua only when the curated option surface does not already cover what you
need.
