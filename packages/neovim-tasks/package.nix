{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "neovim-tasks";
  version = "0-unstable-07-02-2025";

  src = pkgs.fetchFromGitHub {
    owner = "Shatur";
    repo = "neovim-tasks";
    rev = "decb21552afcb9cb0d4f73eae7e6c3763efbe9a9";
    hash = "sha256-aU91caLi7agRhMvVcqPejh6g3/ZQUcM7fRz7t5OY3tc=";
  };

  dependencies = with pkgs.vimPlugins; [
    plenary-nvim
    nvim-dap
  ];
}
