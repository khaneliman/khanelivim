# Customizing Khanelivim

Khanelivim is meant to be customized in layers, from the highest-level option
surface down to raw plugin or Lua overrides when needed.

## Preferred Order

Use the narrowest layer that solves the problem cleanly:

1. `khanelivim.*` options
2. `plugins.*` overrides
3. `extraConfigLua`

This keeps customizations easier to reason about and less likely to break when
internal plugin wiring changes.

## 1. Use `khanelivim.*` First

The curated `khanelivim.*` options are the intended public surface for choosing
major workflows, UI components, and language tooling.

Examples:

```nix
{
  khanelivim.editor.fileManager = "yazi";
  khanelivim.ui.keybindingHelp = "which-key";
  khanelivim.lsp.java = "nvim-java";
}
```

Use the generated `Options Reference` when looking for the supported knobs.

## 2. Override `plugins.*` When The Public Surface Is Too Coarse

Drop to plugin-specific settings when the feature already exists in the plugin,
but Khanelivim does not expose a dedicated `khanelivim.*` option for it.

Examples:

```nix
{
  plugins.lualine.settings.options.theme = "gruvbox";
  plugins.typescript-tools.settings.settings.tsserver_max_memory = "auto";
}
```

This is still a Nix-level override, so it is usually safer than patching things
with raw Lua.

## 3. Use `extraConfigLua` For Truly Local Behavior

Use `extraConfigLua` when you need editor behavior that is:

- specific to your own setup
- too small to justify a dedicated option
- not cleanly expressed through existing module settings

Example:

```nix
{
  extraConfigLua = ''
    vim.opt.relativenumber = false
  '';
}
```

Prefer small, targeted Lua additions over large private rewrites of the config.

## Extend Instead Of Forking

The normal customization model is to evaluate a base config, then extend it with
your own module overrides.

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

This lets you keep the upstream module graph and only replace the parts you
actually care about.

## What To Avoid

- Editing `modules/nixvim/plugins/*` just to customize your own local install
- Copying large chunks of generated or internal config into `extraConfigLua`
- Treating internal module layout as a stable public API

If the change is broadly useful, it should usually become a new `khanelivim.*`
option rather than a permanent private patch.
