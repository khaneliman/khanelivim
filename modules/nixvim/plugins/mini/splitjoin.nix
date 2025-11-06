{ config, lib, ... }:
{
  plugins.mini-splitjoin = lib.mkIf (config.khanelivim.text.splitJoin == "mini-splitjoin") {
    enable = true;
    settings = {
      mappings = {
        toggle = "gS"; # Toggle split/join
      };
    };
  };

  plugins.which-key.settings.spec = lib.mkIf config.plugins.mini-splitjoin.enable [
    {
      __unkeyed-1 = "gS";
      desc = "Toggle split/join";
      icon = "󰘞";
    }
  ];

  keymaps = lib.mkIf config.plugins.mini-splitjoin.enable [
    {
      mode = "n";
      key = "<leader>tj";
      action = "gS";
      options = {
        desc = "Toggle split/join";
        remap = true;
      };
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>cj";
      action = "gS";
      options = {
        desc = "Split/Join";
        remap = true;
      };
    }
  ];
}
