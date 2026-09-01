{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "resolve.nvim";
  version = "0-unstable-01-25-2026";

  src = pkgs.fetchFromGitHub {
    owner = "spacedentist";
    repo = "resolve.nvim";
    rev = "1ed8bcc9ce7d43a0e8e05d0001c9cadb822d95a8";
    hash = "sha256-BuGUDSD/RdzcpFrQ51M48XabNAwyQEZvQG8xOPZPZcA=";
  };
}
