{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  name = "java-debug-bundle";
  src = pkgs.vscode-extensions.vscjava.vscode-java-debug;
  buildPhase = "
    mkdir -p $out
    ";
  installPhase = ''
    cp share/vscode/extensions/vscjava.vscode-java-debug/server/* $out
  '';
}
