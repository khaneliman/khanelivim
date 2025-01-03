{ pkgs }:
pkgs.tree-sitter.buildGrammar {
  language = "nu";
  version = "e3b4c967937cad628dca09bd098cd780d8288750";

  src = pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = "e3b4c967937cad628dca09bd098cd780d8288750";
    hash = "sha256-DlvBRKDXOJCqyJE0BJn8omqF50pQmnceiYsihJa/opg=";
  };

  meta.homepage = "https://github.com/nushell/tree-sitter-nu";
}
