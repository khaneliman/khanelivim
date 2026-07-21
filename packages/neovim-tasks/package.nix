{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "neovim-tasks";
  version = "0-unstable-07-01-2026";

  src = pkgs.fetchFromGitHub {
    owner = "Shatur";
    repo = "neovim-tasks";
    rev = "053c566cca93cfbf64c22f5f0b87d834cfc0e78c";
    hash = "sha256-JgkeKGjlmXqa+/hh5iss59uOvxBFXHorjhou4ftAk0Y=";
  };

  dependencies = with pkgs.vimPlugins; [
    plenary-nvim
    nvim-dap
  ];
}
