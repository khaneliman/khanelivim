{ config, lib, ... }:
{
  plugins = {
    dap-virtual-text = {
      enable = lib.elem "dap-virtual-text" config.khanelivim.debugging.adapters;

      lazyLoad.settings = {
        before.__raw = lib.mkIf config.plugins.lz-n.enable ''
          function()
            require('lz.n').trigger_load('nvim-dap')
          end
        '';
        cmd = [
          "DapVirtualTextEnable"
          "DapVirtualTextForceRefresh"
          "DapVirtualTextToggle"
        ];
      };
    };
  };
}
