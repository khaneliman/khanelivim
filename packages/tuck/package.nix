{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "tuck.nvim";
  version = "0-unstable-02-12-2026";

  src = pkgs.fetchFromGitHub {
    owner = "nuvic";
    repo = "tuck.nvim";
    rev = "758d2888c93aab61bd97b25dbacce509c3dcc30e";
    hash = "sha256-HaNw/tFJev5ank1gQZkDraaWhZkz5YLwRAvipRCGzZE=";
  };
}
