{
  filetype = {
    extension = {
      avsc = "json";
      rasi = "scss";
      tl = "teal";
      ignore = "gitignore";
    };

    pattern = {
      ".*/hypr/.*%.conf" = "hyprlang";
      "flake.lock" = "json";
      ".*helm-chart*.yaml" = "helm";
    };
  };
}
