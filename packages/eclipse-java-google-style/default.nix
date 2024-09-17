{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  name = "eclipse-java-google-style";
  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
    sha256 = "sha256-51Uku2fj/8iNXGgO11JU4HLj28y7kcSgxwjc+r8r35E=";
  };
  dontUnpack = true;
  buildPhase = ''
    mkdir -p $out
  '';
  installPhase = ''
    cp ./* $out
  '';
}
