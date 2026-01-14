{
  config,
  lib,
  ...
}:
{
  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      [
        {
          mode = "n";
          key = "<leader>fS";
          action = ''<CMD>lua Snacks.picker.spelling({layout = { preset = "select" }})<CR>'';
          options = {
            desc = "Find spelling suggestions";
          };
        }
        {
          mode = "n";
          key = "<leader>fT";
          action = "<cmd>lua Snacks.picker.colorschemes()<cr>";
          options = {
            desc = "Find theme";
          };
        }
        {
          mode = "n";
          key = "<leader>f,";
          action = ''<cmd>lua Snacks.picker.icons({layout = { preset = "select" }})<cr>'';
          options = {
            desc = "Find icons";
          };
        }
        {
          mode = "n";
          key = "<leader>uC";
          action = "<cmd>lua Snacks.picker.colorschemes()<cr>";
          options = {
            desc = "Colorschemes";
          };
        }
      ];
}
