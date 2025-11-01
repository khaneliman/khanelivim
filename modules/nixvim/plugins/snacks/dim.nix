{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        dim.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "dim" config.plugins.snacks.settings
        && config.plugins.snacks.settings.dim.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>uz";
          action.__raw = ''
            function()
              if vim.g.snacks_dim_enabled == nil then
                vim.g.snacks_dim_enabled = false
              end

              vim.g.snacks_dim_enabled = not vim.g.snacks_dim_enabled

              if vim.g.snacks_dim_enabled then
                Snacks.dim()
              else
                Snacks.dim.disable()
              end

              vim.notify(string.format("Dim %s", vim.g.snacks_dim_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
            end
          '';
          options = {
            desc = "Toggle Dim";
          };
        }
      ];
}
