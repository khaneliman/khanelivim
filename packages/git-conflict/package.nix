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
    (pkgs.fetchpatch {
      name = "validate";
      url = "https://github.com/khaneliman/git-conflict.nvim/commit/f7906dbd2d1321a9ee46a9ec4ed9cc3a526b68ef.patch";
      hash = "sha256-qTW15tWD8VFPfq7rcWmPLvF4DfS7Xn6ASo38PpAw7WI=";
    })
  ];
}
