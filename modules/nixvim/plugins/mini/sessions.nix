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
      __unkeyed-1 = "<leader>S";
      group = "Sessions";
      icon = "󰘛";
    }
  ];

  keymaps = lib.optionals config.plugins.mini-sessions.enable [
    {
      mode = "n";
      key = "<leader>Sl";
      action.__raw = "function() require('mini.sessions').read() end";
      options.desc = "Load session";
    }
    {
      mode = "n";
      key = "<leader>Sw";
      action.__raw = "function() require('mini.sessions').write() end";
      options.desc = "Write current session";
    }
    {
      mode = "n";
      key = "<leader>Sd";
      action.__raw = "function() require('mini.sessions').delete() end";
      options.desc = "Delete a session";
    }
  ];
}
