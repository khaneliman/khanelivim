{ config, lib, ... }:
{
  plugins = {
    indent-blankline = {
      enable =
        (!lib.hasAttr "indent" config.plugins.snacks.settings)
        || !config.plugins.snacks.settings.indent.enabled;

      settings = {
        scope.enabled = false;
      };
    };
  };

  keymaps = lib.optionals config.plugins.indent-blankline.enable [
    {
      mode = "n";
      key = "<leader>ui";
      action = "<cmd>IBLToggle<CR>";
      options = {
        desc = "Indent-Blankline toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>uI";
      action = "<cmd>IBLToggleScope<CR>";
      options = {
        desc = "Indent-Blankline Scope toggle";
      };
    }
  ];
}
