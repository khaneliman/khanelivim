{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-nerdfont.nvim";
  version = "2025-02-06";
  src = pkgs.fetchFromGitHub {
    owner = "MahanRahmati";
    repo = "blink-nerdfont.nvim";
    rev = "2f3cedda78dcf4ef547128ce7f72f7b80e25501d";
    sha256 = "17cab659iiv6l67xjwk5kj624nhxmmng7xjbgimr4v86yhmirk4m";
  };
  meta.homepage = "https://github.com/MahanRahmati/blink-nerdfont.nvim/";

  dependencies = [ pkgs.vimPlugins.blink-cmp ];
}
