{ lib, config, ... }:
{
  plugins = {
    fastaction = {
      enable = true;
    };
  };

  keymaps = lib.mkIf config.plugins.fastaction.enable [
    {
      mode = "n";
      key = "<leader>lc";
      action = ''<cmd>lua require('fastaction').code_action()<cr>'';
      options = {
        desc = "Fastaction code action";
      };
    }
    {
      mode = "v";
      key = "<leader>lc";
      action = ''<cmd>lua require('fastaction').range_code_action()<cr>'';
      options = {
        desc = "Fastaction code action";
      };
    }
  ];
}
