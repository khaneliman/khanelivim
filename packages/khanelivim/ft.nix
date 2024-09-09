{
  filetype = {
    extension = {
      "avsc" = "json";
      "rasi" = "scss";
      "ignore" = "gitignore";
      "http" = "http";
    };

    pattern = {
      ".*/hypr/.*%.conf" = "hyprlang";
      "flake.lock" = "json";
      ".*helm-chart*.yaml" = "helm";
    };
  };
}
