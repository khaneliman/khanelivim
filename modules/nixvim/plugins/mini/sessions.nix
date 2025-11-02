{ config, lib, ... }:
{
  plugins.mini-sessions = lib.mkIf (lib.elem "mini-sessions" config.khanelivim.utilities.sessions) {
    enable = true;
    settings = {
      autoread = false; # Don't automatically read session on startup
      autowrite = true; # Automatically write session on exit
      directory = ""; # Use default directory
    };
  };

  plugins.which-key.settings.spec = lib.optionals config.plugins.mini-sessions.enable [
    {
      __unkeyed-1 = "<leader>P";
      group = "Sessions";
      icon = "󰘛";
    }
  ];

  keymaps = lib.optionals config.plugins.mini-sessions.enable [
    {
      mode = "n";
      key = "<leader>Pl";
      action.__raw = "function() require('mini.sessions').read() end";
      options.desc = "Load session";
    }
    {
      mode = "n";
      key = "<leader>Pw";
      action.__raw = "function() require('mini.sessions').write() end";
      options.desc = "Write current session";
    }
    {
      mode = "n";
      key = "<leader>Pd";
      action.__raw = "function() require('mini.sessions').delete() end";
      options.desc = "Delete a session";
    }
  ];
}
