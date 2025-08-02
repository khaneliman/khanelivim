{
  vimUtils,
  pkgs,
  neovim-tasks,
}:
vimUtils.buildVimPlugin {
  pname = "neotest-catch2";
  version = "0-unstable-01-22-2024";

  src = pkgs.fetchFromGitHub {
    owner = "rosstang";
    repo = "neotest-catch2";
    rev = "772e10c4bb0b6ac0444c0387d22da9117908d7aa";
    hash = "sha256-7JMBEo5XpUSq69P0bup+yO40QwDZBXJ+q+ol0q/iAes=";
  };

  propagatedBuildInputs = [
    pkgs.luajitPackages.luaexpat
  ];

  dependencies = with pkgs.vimPlugins; [
    plenary-nvim
    neotest
    nvim-nio
    neovim-tasks
  ];
}
