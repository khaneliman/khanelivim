{ config, lib, ... }:
{
  plugins.yazi = {
    enable = true;

    lazyLoad = {
      settings = {
        cmd = [
          "Yazi"
          "Yazi cwd"
          "Yazi toggle"
        ];
      };
    };
  };

  keymaps = lib.optionals config.plugins.yazi.enable [
    {
      mode = "n";
      key = "<leader>e";
      action = "<CMD>Yazi toggle<CR>";
      options = {
        desc = "Yazi toggle";
      };
    }
  ];
}
