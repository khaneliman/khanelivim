{ pkgs }:
pkgs.tree-sitter.buildGrammar rec {
  language = "nu";
  version = "9822fc63a62ff87939c88ead9f381f951f092dee";

  src = pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = version;
    hash = "sha256-fcwWrM1KpK1V+TeGqe/iMICOIv7/lA1WZW/8jJXL7WA=";
  };

  meta.homepage = "https://github.com/nushell/tree-sitter-nu";
}
