{
  plugins.helpview = {
    enable = true;

    lazyLoad.settings.ft = "help";

    settings = {

      buf_ignore = [ ];

      mode = [
        "n"
        "x"
        "i"
        "r"
      ];

      hybrid_modes = [
        "i"
        "r"
      ];
    };
  };
}
