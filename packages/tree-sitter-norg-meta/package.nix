{ pkgs }:
pkgs.tree-sitter.buildGrammar {
  language = "norg-meta";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "nvim-neorg";
    repo = "tree-sitter-norg-meta";
    rev = "refs/tags/v0.1.0";
    hash = "sha256-8qSdwHlfnjFuQF4zNdLtU2/tzDRhDZbo9K54Xxgn5+8=";
  };

  fixupPhase = ''
    mkdir -p $out/queries/norg-meta
    mv $out/queries/*.scm $out/queries/norg-meta/
  '';

  meta.homepage = "https://github.com/nvim-neorg/tree-sitter-norg-meta";
}
