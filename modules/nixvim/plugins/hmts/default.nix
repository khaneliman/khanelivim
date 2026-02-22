{
  plugins = {
    hmts = {
      # hmts.nvim documentation
      # See: https://github.com/calops/hmts.nvim
      # inherit (config.plugins.treesitter) enable;
      enable = false;

      lazyLoad.settings.ft = "nix";
    };
  };
}
