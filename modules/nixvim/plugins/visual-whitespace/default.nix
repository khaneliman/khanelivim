{
  plugins.visual-whitespace = {
    enable = true;
    lazyLoad.settings.keys = [
      {
        __unkeyed-1 = "<leader>uW";
        __unkeyed-3 = "<CMD>lua require('visual-whitespace').toggle()<CR>";
        mode = [
          "v"
          "n"
        ];
        desc = "White space character toggle";
      }
    ];

    settings = {
      enabled = false;
    };
  };
}
