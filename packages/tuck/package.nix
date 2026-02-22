{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "tuck.nvim";
  version = "0-unstable-02-21-2026";

  src = pkgs.fetchFromGitHub {
    owner = "nuvic";
    repo = "tuck.nvim";
    rev = "a5a4f0e7eaea4c4303311f11b002a6a2c51a69d5";
    hash = "sha256-e759w9pUfnm9gPlYeS23XeAmA5Tl3HpT9KLPtZYIns8=";
  };
}
