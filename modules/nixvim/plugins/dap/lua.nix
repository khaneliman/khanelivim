{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Not needed?
  # extraLuaPackages = ps: [
  #   ps.nlua
  # ];

  extraPlugins = with pkgs.vimPlugins; [
    one-small-step-for-vimkind
  ];

  plugins = {
    dap = {
      luaConfig.content = ''
        local dap = require("dap")
        dap.adapters.nlua = function(callback, conf)
          local adapter = {
            type = "server",
            host = conf.host or "127.0.0.1",
            port = conf.port or 8086,
          }
          if conf.start_neovim then
            local dap_run = dap.run
            dap.run = function(c)
              adapter.port = c.port
              adapter.host = c.host
            end
            require("osv").run_this()
            dap.run = dap_run
          end
          callback(adapter)
          end
      '';
      # TODO: support lua in nixvim
      # adapters = {
      #   servers = {
      #     nlua = {
      #       host = "127.0.0.1";
      #       port = 8086;
      #     };
      #   };
      # };

      configurations = {
        lua = [
          {
            type = "nlua";
            request = "attach";
            name = "Run this file";
            start_neovim = { };
          }
          {
            type = "nlua";
            request = "attach";
            name = "Attach to running Neovim instance (port = 8086)";
            port = 8086;
          }
        ];
      };
    };
  };

  keymaps = lib.optionals config.plugins.dap.enable [
    {
      mode = "n";
      key = "<leader>dL";
      action = "<CMD>lua require'osv'.launch({port = 8086}) <CR>";
      options = {
        desc = "nlua Launch";
      };
    }
  ];
}
