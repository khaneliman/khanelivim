{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  pname = "monaspace.nvim";
  version = "2025-01-14";
  src = fetchFromGitHub {
    owner = "jackplus-xyz";
    repo = "monaspace.nvim";
    rev = "8f6e5e64393b530fd1d8e0ea96c51ffbb4046186";
    sha256 = "08c5kj2wmlykamww1bilgws45mmx8yqb4y0f58cazf3wl1rjbldr";
  };
  meta.homepage = "https://github.com/jackplus-xyz/monaspace.nvim/";
}
