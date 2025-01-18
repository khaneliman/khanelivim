_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = "2025-01-18";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "74feefc52284e2ebf93ad815ec5aaeec918d4dc2";
        sha256 = "sha256-TM/d8PSatlnQNw1DA8QgJaAcnjugNAj5Uim87W7vwjM=";
      };
      nvimSkipModule = oldAttrs.nvimSkipModule ++ [
        "snacks.picker.config.highlights"
        "snacks.picker.actions"
        "snacks.picker.util.db"
      ];
    });
  };
}
