{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-conventional-commits";
  version = "2025-02-18";
  src = pkgs.fetchFromGitHub {
    owner = "disrupted";
    repo = "blink-cmp-conventional-commits";
    rev = "e7ce3ddcc6d4044067d6d77ab41d480202e814ad";
    sha256 = "0m72nyg3pm1ig04hvch6lzd4hy77dnmdxxmbq154qwkjhbm0bs6m";
  };
}
