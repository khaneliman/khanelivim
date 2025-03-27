{
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-dap-view";
  version = "0-unstable-2025-03-18";

  src = pkgs.fetchFromGitHub {
    owner = "igorlfs";
    repo = "nvim-dap-view";
    rev = "8fff34699823c354815891d7081972ef5166a31e";
    hash = "sha256-N94XyDkroiJ+0AMJmHyGmwxJvblwLuOebwTIYh5CXKg=";
  };
  dependencies = [ pkgs.vimPlugins.nvim-dap ];
}
