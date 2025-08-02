{ pkgs }:
pkgs.tree-sitter.buildGrammar {
  language = "kulala_http";
  version = "5.3.2";
  src = pkgs.fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala.nvim";
    rev = "6b6e1c8b538cce6654cfc5fb3e4a3acfa316ce57";
    hash = "sha256-cFjYRw93tR439RGSwNeBo3i4ep0jx/Jcfx9UTS32Tx8=";
  };
  location = "lua/tree-sitter";

  meta.homepage = "https://github.com/mistweaverco/kulala.nvim";
}
