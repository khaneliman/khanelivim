{
  vimUtils,
  pkgs,
}:

vimUtils.buildVimPlugin {
  pname = "neotest-bun";
  version = "0-unstable-2026-01-05";

  src = pkgs.fetchFromGitHub {
    owner = "Arthur944";
    repo = "neotest-bun";
    rev = "af0f8684cd00a96f1e0359f1aeff2b9bf7a0ec88";
    hash = "sha256-Y1I0zW8S8/Fz46rPIkHzTGbm7C8BXOfjq+V19YrzPlo=";
  };

  dependencies = with pkgs.vimPlugins; [
    neotest
    nvim-nio
  ];
}
