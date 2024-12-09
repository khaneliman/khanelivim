{ config, lib, ... }:
{
  plugins = {
    persistence = {
      enable = true;
    };

    which-key.settings.spec = lib.optionals config.plugins.persistence.enable [
      {
        __unkeyed = "<leader>P";
        group = "Persistence";
        icon = "󰘛";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.persistence.enable [
    {
      mode = "n";
      key = "<leader>Pl";
      action.__raw = "function() require('persistence').load() end";
      options.desc = "Load the session for the current directory";
    }
    {
      mode = "n";
      key = "<leader>Ps";
      action.__raw = "function() require('persistence').select() end";
      options.desc = "Select a session to load";
    }
    {
      mode = "n";
      key = "<leader>PL";
      action.__raw = "function() require('persistence').load({ last = true }) end";
      options.desc = "Load the last session";
    }
    {
      mode = "n";
      key = "<leader>PS";
      action.__raw = "function() require('persistence').stop() end";
      options.desc = "Stop Persistence";
    }
  ];
}
