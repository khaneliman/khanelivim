{
  plugins.markview = {
    enable = true;

    lazyLoad = {
      settings = {
        ft = "markdown";
      };
    };
    settings = {
      buf_ignore = [ ];

      modes = [
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
