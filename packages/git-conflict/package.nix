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

  patches = [
    (pkgs.fetchpatch {
      name = "disable_diagnostics";
      url = "https://patch-diff.githubusercontent.com/raw/akinsho/git-conflict.nvim/pull/106.patch";
      hash = "sha256-RWmEMzb3W7FNjNwkH0wn7HYY7u0S8DzXs8khWzH5MoY=";
    })
    (pkgs.fetchpatch {
      name = "highlight";
      url = "https://patch-diff.githubusercontent.com/raw/akinsho/git-conflict.nvim/pull/108.patch";
      hash = "sha256-1jCdRiRrO3eXNhxr7SSxl+rMEK5kG7/kHfWlgF2eO4M=";
    })
  ];
}
