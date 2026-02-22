{ config, lib, ... }:
{
  plugins = {
    persistence = {
      # persistence.nvim documentation
      # See: https://github.com/folke/persistence.nvim
      enable = lib.elem "persistence" config.khanelivim.utilities.sessions;

      lazyLoad.settings.event = "BufReadPre";
    };

  };

  keymaps = lib.optionals config.plugins.persistence.enable [
    {
      mode = "n";
      key = "<leader>Sl";
      action.__raw = "function() require('persistence').load() end";
      options.desc = "Load the session for the current directory";
    }
    {
      mode = "n";
      key = "<leader>Ss";
      action.__raw = "function() require('persistence').select() end";
      options.desc = "Select a session to load";
    }
    {
      mode = "n";
      key = "<leader>SL";
      action.__raw = "function() require('persistence').load({ last = true }) end";
      options.desc = "Load the last session";
    }
    {
      mode = "n";
      key = "<leader>SS";
      action.__raw = "function() require('persistence').stop() end";
      options.desc = "Stop Persistence";
    }
  ];
}
