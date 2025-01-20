{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "git-conflict";
  version = "2.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "akinsho";
    repo = "git-conflict.nvim";
    tag = "v2.1.0";
    hash = "sha256-1t0kKxTGLuOvuRkoLgkoqMZpF+oKo8+gMsTdgPsSb+8=";
  };
}
