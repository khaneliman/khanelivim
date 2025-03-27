{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "nu";
  version = "c10340b5bb3789f69182acf8f34c3d4fc24d2fe1";

  src = pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = version;
    hash = "sha256-EyaFrO9NE2Ivo8YTXZ6nmC31PB7WFbFdz7AMRw0ooHo=";
  };

  meta.homepage = "https://github.com/nushell/tree-sitter-nu";
}
