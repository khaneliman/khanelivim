{
  plugins = {
    hmts = {
      # inherit (config.plugins.treesitter) enable;
      enable = false;

      lazyLoad.settings.ft = "nix";
    };
  };
}
