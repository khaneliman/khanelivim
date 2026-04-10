{ lib, ... }:
let
  mkFiletypeMap = filetype: names: lib.genAttrs names (_: filetype);
in
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

    filename = lib.mkMerge [
      (mkFiletypeMap "yaml.gitlab" [
        ".gitlab-ci.yaml"
        ".gitlab-ci.yml"
      ])
      (mkFiletypeMap "yaml.docker-compose" [
        "compose.yaml"
        "compose.yml"
        "docker-compose.yaml"
        "docker-compose.yml"
      ])
    ];

    pattern = lib.mkMerge [
      {
        ".*/hypr/.*%.conf" = "hyprlang";
        "flake.lock" = "json";
        ".*helm-chart*.yaml" = "helm";
      }
      # These yaml.* subtypes are advertised by nvim-lspconfig's yamlls
      # defaults; register common filenames so those filetypes are usable.
      (mkFiletypeMap "yaml.docker-compose" [
        ".*/compose%..+%.yaml"
        ".*/compose%..+%.yml"
        ".*/docker%-compose%..+%.yaml"
        ".*/docker%-compose%..+%.yml"
      ])
      (mkFiletypeMap "yaml.helm-values" [
        ".*/values%.yaml"
        ".*/values%.yml"
        ".*/values%-.+%.yaml"
        ".*/values%-.+%.yml"
      ])
    ];
  };
}
