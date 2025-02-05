{ config, lib, ... }:
{
  plugins = {
    # dap.luaConfig.pre = lib.mkIf (config.plugins.java.enable && config.plugins.java.lazyLoad.enable) ''
    #   vim.cmd('JavaDapConfig')
    # '';

    java = {
      enable = true;

      # lazyLoad = {
      #   settings = {
      #     ft = "java";
      #   };
      # };

      settings = {
        jdk = {
          auto_install = false;
        };
      };
    };
  };
}
