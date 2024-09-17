{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  name = "java-test-bundle";
  src = pkgs.vscode-extensions.vscjava.vscode-java-test;
  buildPhase = "
    mkdir -p $out
    ";
  installPhase = ''
    cp share/vscode/extensions/vscjava.vscode-java-test/server/* $out
  '';
}
