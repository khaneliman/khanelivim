{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "neovim-tasks";
  version = "0-unstable-09-08-2025";

  src = pkgs.fetchFromGitHub {
    owner = "Shatur";
    repo = "neovim-tasks";
    rev = "820d3b8fb3b7b5e7334bc84cdd4eacc7d1e6f990";
    hash = "sha256-hEVXnkQJyuLFjHngYtPZ3VQPoSrQ40VW1LjsHlbQGh8=";
  };

  dependencies = with pkgs.vimPlugins; [
    plenary-nvim
    nvim-dap
  ];
}
