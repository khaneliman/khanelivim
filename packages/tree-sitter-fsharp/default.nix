{ pkgs }:
pkgs.tree-sitter.buildGrammar {
  language = "fsharp";
  version = "0.0.0+rev=f54ac4e";

  src = pkgs.fetchFromGitHub {
    owner = "ionide";
    repo = "tree-sitter-fsharp";
    rev = "f54ac4e66843b5af4887b586888e01086646b515";
    hash = "sha256-zKfMfue20B8sbS1tQKZAlokRV7efMsxBk7ySQmzLo0Y=";
  };

  fixupPhase = ''
    mkdir -p $out/queries/fsharp
    mv $out/queries/*.scm $out/queries/fsharp/
  '';

  meta.homepage = "https://github.com/ionide/tree-sitter-fsharp";
}
