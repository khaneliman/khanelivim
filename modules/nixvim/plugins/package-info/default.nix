_: {
  plugins.package-info = {
    # package-info.nvim documentation
    # See: https://github.com/vuki656/package-info.nvim
    enable = true;

    lazyLoad.settings = {
      event = [ "BufRead package.json" ];
    };

    settings = {
      hide_up_to_date = true;
    };
  };
}
