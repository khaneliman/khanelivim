{ pkgs }:
pkgs.tree-sitter.buildGrammar {
  language = "kulala_http";
  version = "5.3.3";
  src = pkgs.fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala.nvim";
    rev = "0d50e9ce5c992fe507743d8641b36125e668aad4";
    hash = "sha256-4wAZ9ZYK1SfsSuo7TFrm0tHcaahBkwRYNaKVzS8wTXU=";
  };
  location = "lua/tree-sitter";

  meta.homepage = "https://github.com/mistweaverco/kulala.nvim";
}
