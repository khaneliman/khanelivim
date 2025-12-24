_: {
  plugins.package-info = {
    enable = true;

    lazyLoad.settings = {
      event = [ "BufRead package.json" ];
    };

    settings = {
      hide_up_to_date = true;
    };
  };
}
