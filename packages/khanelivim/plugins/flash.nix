{ config, lib, ... }:
{
  plugins = {
    flash = {
      enable = true;
    };
  };

  keymaps = lib.mkIf config.plugins.flash.enable [
    {
      key = "s";
      action.__raw = ''function() require("flash").jump() end'';
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash";
    }
    {
      key = "S";
      action.__raw = ''function() require("flash").treesitter() end'';
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash Treesitter";
    }
    {
      key = "r";
      action.__raw = ''function() require("flash").remote() end'';
      mode = [
        "o"
      ];
      options.desc = "Remote Flash";
    }
    {
      key = "R";
      action.__raw = ''function() require("flash").treesitter_search() end'';
      mode = [
        "o"
      ];
      options.desc = "Treesitter Search";
    }
    # { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  ];

}
