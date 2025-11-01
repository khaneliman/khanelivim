{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        scratch.enabled = true;
      };
    };

    which-key.settings.spec =
      lib.mkIf
        (
          config.plugins.snacks.enable
          && lib.hasAttr "scratch" config.plugins.snacks.settings
          && config.plugins.snacks.settings.scratch.enabled
        )
        [
          {
            __unkeyed-1 = "<leader>n";
            group = "Notes";
            icon = " ";
          }
        ];
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "scratch" config.plugins.snacks.settings
        && config.plugins.snacks.settings.scratch.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>nn";
          action = "<cmd>lua Snacks.scratch()<CR>";
          options = {
            desc = "New Scratch Buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>ns";
          action = "<cmd>lua Snacks.scratch.select()<CR>";
          options = {
            desc = "Select Scratch Buffer";
          };
        }
      ];
}
