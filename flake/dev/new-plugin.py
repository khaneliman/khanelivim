#!/usr/bin/env python3
"""
Script to generate new plugin templates for nixvim configuration.
Usage: python3 new-plugin.py <plugin-name> <template-type>
Template types: custom, custom-lazy, nixvim
"""

import argparse
import sys
from pathlib import Path

# Template definitions
CUSTOM_TEMPLATE = """{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.PLUGIN_NAME = {
    enable = lib.mkEnableOption "PLUGIN_NAME" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "PLUGIN_NAME" {
      default = "PLUGIN_NAME-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for PLUGIN_NAME";
    };
  };

  config = lib.mkIf config.plugins.PLUGIN_NAME.enable {
    extraPlugins = [
      config.plugins.PLUGIN_NAME.package
    ];

    extraConfigLua = ''
      require('PLUGIN_NAME').setup(${lib.generators.toLua { } config.plugins.PLUGIN_NAME.settings})
    '';

    # TODO: Optional: Add keymaps for the plugin
    keymaps = [
      {
        mode = "n";
        key = "<leader>XX";
        action = "<cmd>PluginCommand<CR>";
        options = {
          desc = "Plugin description";
        };
      }
    ];
  };
}
"""

CUSTOM_LAZY_TEMPLATE = """{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.PLUGIN_NAME = {
    enable = lib.mkEnableOption "PLUGIN_NAME" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "PLUGIN_NAME" {
      default = "PLUGIN_NAME-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for PLUGIN_NAME";
    };
  };

  config =
    let
      luaConfig = # Lua
        ''
          require('PLUGIN_NAME').setup(${lib.generators.toLua { } config.plugins.PLUGIN_NAME.settings})
        '';
    in
    lib.mkIf config.plugins.PLUGIN_NAME.enable {
      # Conditional Lua config - only load if lz-n is disabled
      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      extraPlugins = [
        {
          plugin = config.plugins.PLUGIN_NAME.package;
          optional = config.plugins.lz-n.enable;
        }
      ];

      # TODO: Extra packages needed by the plugin
      # extraPackages = with pkgs; [
      #   # package-name
      # ];

      # lz-n lazy loading configuration
      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "PLUGIN_NAME.nvim";
              event = [ "DeferredUIEnter" ];
              # TODO: Other lazy loading triggers
              # cmd = [ "PluginCommand" ];
              # ft = [ "filetype" ];
              # keys = [
              #   { __unkeyed-1 = "<leader>XX"; desc = "Plugin action"; }
              # ];
              after = ''
                function()
                  $${luaConfig}
                end
              '';
            }
          ];
        };
      };

      # TODO: Add keymaps for the plugin
      keymaps = [
        {
          mode = "n";
          key = "<leader>XX";
          action = "<cmd>PluginCommand<CR>";
          options = {
            desc = "Plugin description";
          };
        }
      ];
    };
}
"""

NIXVIM_TEMPLATE = """{ config, lib, ... }:
{
  # Template for nixvim upstream plugin
  # Replace PLUGIN_NAME with actual plugin name
  plugins.PLUGIN_NAME = {
    enable = true;

    # Lazy loading configuration
    lazyLoad.settings = {
      event = [
        "DeferredUIEnter"
      ];
    };

    # TODO: Plugin settings
    settings = {
      # Add plugin-specific configuration here
    };
  };

  # TODO: Add keymaps for the plugin
  keymaps = lib.optionals config.plugins.PLUGIN_NAME.enable [
    {
      mode = "n";
      key = "<leader>XX";
      action = "<cmd>PluginCommand<CR>";
      options = {
        desc = "Plugin description";
      };
    }
  ];
}
"""


def create_plugin_directory(plugin_name, base_path):
    """Create the plugin directory structure."""
    plugin_dir = base_path / "modules" / "nixvim" / "plugins" / plugin_name
    plugin_dir.mkdir(parents=True, exist_ok=True)
    return plugin_dir


def get_template_content(template_type):
    """Get the template content based on type."""
    templates = {
        "custom": CUSTOM_TEMPLATE,
        "custom-lazy": CUSTOM_LAZY_TEMPLATE,
        "nixvim": NIXVIM_TEMPLATE,
    }

    if template_type not in templates:
        raise ValueError(f"Unknown template type: {template_type}")

    return templates[template_type]


def substitute_plugin_name(template_content, plugin_name):
    """Replace PLUGIN_NAME placeholder with actual plugin name."""
    return template_content.replace("PLUGIN_NAME", plugin_name)


def main():
    parser = argparse.ArgumentParser(
        description="Generate new plugin templates for nixvim configuration"
    )
    parser.add_argument("plugin_name", help="Name of the plugin (e.g., 'my-plugin')")
    parser.add_argument(
        "template_type",
        choices=["custom", "custom-lazy", "nixvim"],
        help="Type of template to generate",
    )
    parser.add_argument(
        "--base-path",
        type=Path,
        default=Path.cwd(),
        help="Base path of the project (default: current directory)",
    )

    args = parser.parse_args()

    try:
        # Validate we're in the right directory
        modules_path = args.base_path / "modules" / "nixvim" / "plugins"
        if not modules_path.exists():
            print(
                f"Error: {modules_path} does not exist. Are you in the right directory?"
            )
            sys.exit(1)

        # Create plugin directory
        plugin_dir = create_plugin_directory(args.plugin_name, args.base_path)

        # Get template content
        template_content = get_template_content(args.template_type)

        # Substitute plugin name
        final_content = substitute_plugin_name(template_content, args.plugin_name)

        # Write to default.nix
        output_file = plugin_dir / "default.nix"
        output_file.write_text(final_content)

        print(f"✓ Created plugin template at {output_file}")
        print(f"  Plugin: {args.plugin_name}")
        print(f"  Template: {args.template_type}")
        print("\nNext steps:")
        print(f"  1. Edit {output_file} to configure the plugin")
        print("  2. Add the plugin to your modules/nixvim/plugins/default.nix imports")
        print("  3. Run 'nix flake check' to verify the configuration")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
