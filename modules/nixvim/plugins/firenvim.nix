{ config, lib, ... }:
{
  plugins = {
    firenvim = {
      enable = true;
      # NOTE: Call the installation for first time use
      # :call firenvim#install(0)

      settings = {
        localSettings = {
          ".*" = {
            cmdline = "neovim";
            content = "text";
            priority = 0;
            selector = "textarea";
            takeover = "never";
          };
        };
      };
    };
  };

  autoCmd = lib.optionals config.plugins.firenvim.enable [
    {
      event = "UIEnter";
      callback = {
        __raw = ''
          function(event)
              local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
              if client ~= nil and client.name == "Firenvim" then
                  vim.o.laststatus = 0
                  vim.o.showtabline = 0
                  require('lualine').hide()
                  local ok, _ = pcall(vim.cmd, "colorscheme sorbet")
              end
          end
        '';
      };
    }
  ];
}
