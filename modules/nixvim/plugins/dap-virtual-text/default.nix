{
  plugins = {
    dap-virtual-text = {
      enable = true;

      lazyLoad.settings = {
        before.__raw = ''
          function()
            require('lz.n').trigger_load('nvim-dap')
          end
        '';
        cmd = [
          "DapVirtualTextToggle"
          "DapVirtualTextEnable"
        ];
      };
    };
  };
}
