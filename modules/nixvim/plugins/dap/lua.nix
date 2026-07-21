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

  # NOTE: Allows debugging personal configuration
  # `nvim --cmd "lua init_debug=true"`
  extraConfigLuaPre = lib.mkIf config.plugins.dap.enable (
    lib.mkOrder 2 ''
      if init_debug then
        require"osv".launch({port=8086, blocking=true})
      end
    ''
  );

  extraPlugins = lib.mkIf config.plugins.dap.enable [
    pkgs.vimPlugins.one-small-step-for-vimkind
  ];

  plugins = {
    dap = {
      adapters.nlua.__raw = ''
        function(callback, conf)
          local adapter = {
            type = "server",
            host = conf.host or "127.0.0.1",
            port = conf.port or 8086,
          }
          if conf.start_neovim then
            local server = require("osv").launch({
              host = adapter.host,
              port = adapter.port,
              blocking = false,
            })
            if server then
              adapter.host = server.host or adapter.host
              adapter.port = server.port or adapter.port
            end
          end
          callback(adapter)
        end
      '';

      configurations = {
        lua = [
          {
            type = "nlua";
            request = "attach";
            name = "Launch current Neovim instance";
            port = 8086;
            start_neovim = true;
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
