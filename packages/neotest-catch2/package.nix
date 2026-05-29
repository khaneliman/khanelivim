{
  vimUtils,
  pkgs,
  neovim-tasks,
}:
let
  luaexpat = pkgs.luajitPackages.luaexpat;
  luaexpatRtp = pkgs.runCommand "luaexpat-neovim-rtp" { } ''
    mkdir -p $out/lua
    ln -s ${luaexpat}/lib/lua/5.1/lxp.so $out/lua/lxp.so
  '';
in
vimUtils.buildVimPlugin {
  pname = "neotest-catch2";
  version = "0-unstable-01-22-2024";

  src = pkgs.fetchFromGitHub {
    owner = "rosstang";
    repo = "neotest-catch2";
    rev = "772e10c4bb0b6ac0444c0387d22da9117908d7aa";
    hash = "sha256-7JMBEo5XpUSq69P0bup+yO40QwDZBXJ+q+ol0q/iAes=";
  };

  requiredLuaModules = [
    luaexpat
  ];

  dependencies = with pkgs.vimPlugins; [
    plenary-nvim
    neotest
    nvim-nio
    neovim-tasks
  ];

  nativeCheckInputs = [
    luaexpatRtp
  ];
}
