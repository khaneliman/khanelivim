{
  filetype = {
    extension = {
      avsc = "json";
      gotmpl = "gotmpl";
      mdx = "markdown.mdx";
      rasi = "scss";
      tl = "teal";
      ignore = "gitignore";
    };

    filename = {
      ".gitlab-ci.yaml" = "yaml.gitlab";
      ".gitlab-ci.yml" = "yaml.gitlab";
      "compose.yaml" = "yaml.docker-compose";
      "compose.yml" = "yaml.docker-compose";
      "docker-compose.yaml" = "yaml.docker-compose";
      "docker-compose.yml" = "yaml.docker-compose";
    };

    pattern = {
      ".*/hypr/.*%.conf" = "hyprlang";
      "flake.lock" = "json";
      ".*helm-chart*.yaml" = "helm";
      # These yaml.* subtypes are advertised by nvim-lspconfig's yamlls
      # defaults; register common filenames so those filetypes are usable.
      ".*/compose%..+%.yaml" = "yaml.docker-compose";
      ".*/compose%..+%.yml" = "yaml.docker-compose";
      ".*/docker%-compose%..+%.yaml" = "yaml.docker-compose";
      ".*/docker%-compose%..+%.yml" = "yaml.docker-compose";
      ".*/values%.yaml" = "yaml.helm-values";
      ".*/values%.yml" = "yaml.helm-values";
      ".*/values%-.+%.yaml" = "yaml.helm-values";
      ".*/values%-.+%.yml" = "yaml.helm-values";
    };
  };
}
