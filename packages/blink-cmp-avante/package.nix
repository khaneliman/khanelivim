{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-avante";
  version = "2025-02-19";
  src = pkgs.fetchFromGitHub {
    owner = "Kaiser-Yang";
    repo = "blink-cmp-avante";
    rev = "e5a1be4c818520385f95fe2663c04e48f5f0c36a";
    sha256 = "13rkypddzpgz6a36s38a30qfx0n3jspd788yvgjdb7dkn0zrvqdg";
  };
  meta.homepage = "https://github.com/Kaiser-Yang/blink-cmp-avante/";
}
