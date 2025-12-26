{ pkgs }:
pkgs.tree-sitter.buildGrammar {
  language = "kulala_http";
  inherit (pkgs.vimPlugins.kulala-nvim) version src meta;
  location = "lua/tree-sitter";
}
