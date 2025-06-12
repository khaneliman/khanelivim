{
  filetype = {
    extension = {
      avsc = "json";
      rasi = "scss";
      ignore = "gitignore";
      razor = "razor";
      cshtml = "razor";
    };

    pattern = {
      ".*/hypr/.*%.conf" = "hyprlang";
      "flake.lock" = "json";
      ".*helm-chart*.yaml" = "helm";
    };
  };
}
