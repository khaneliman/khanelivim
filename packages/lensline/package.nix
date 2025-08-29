{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "lensline-nvim";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "oribarilan";
    repo = "lensline.nvim";
    rev = "1.0.0";
    hash = "sha256-A1dE3PhDU2i7Jms38lUS6zL9xLcTCmvxT0jNzPQ2CvE=";
  };
}
