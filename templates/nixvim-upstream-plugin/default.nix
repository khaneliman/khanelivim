{ config, lib, ... }:
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

    # Plugin settings
    settings = {
      # Add plugin-specific configuration here
    };
  };

  # Optional: Add keymaps for the plugin
  keymaps = lib.optional config.plugins.PLUGIN_NAME.enable [
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
