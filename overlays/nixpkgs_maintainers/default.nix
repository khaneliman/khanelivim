_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    cmp-nixpkgs-maintainers = prev.vimPlugins.cmp-nixpkgs-maintainers.overrideAttrs {
      pname = "cmp-nixpkgs-maintainers";
      version = "2024-10-19";
      src = prev.fetchFromGitHub {
        owner = "GaetanLepage";
        repo = "cmp-nixpkgs-maintainers";
        rev = "86711e7d3e92097b26e53f0b146b93863176377d";
        sha256 = "sha256-NZuDbrKL/ukLIMxbqVzVgzKkKTnw2Zu1/qD/MTIVO2Q=";
      };
      meta.homepage = "https://github.com/GaetanLepage/cmp-nixpkgs-maintainers/";
    };
  };
}
