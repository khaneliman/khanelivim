{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      enable = true;

      settings = {
        bufdelete.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf (config.plugins.snacks.enable && config.plugins.snacks.settings.bufdelete.enabled)
      [
        {
          mode = "n";
          key = "<leader>c";
          action = ''<cmd>lua Snacks.bufdelete.delete()<cr>'';
          options = {
            desc = "Close buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>bc";
          action = ''<cmd>lua Snacks.bufdelete.other()<cr>'';
          options = {
            desc = "Close all buffers but current";
          };
        }
        {
          mode = "n";
          key = "<leader>bC";
          action = ''<cmd>lua Snacks.bufdelete.all()<cr>'';
          options = {
            desc = "Close all buffers";
          };
        }
      ];
}
