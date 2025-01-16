_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = "2025-01-16";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "d82c5bcff5c04452ed682f71e418a2e7a2c0f9c9";
        sha256 = "1a12awf71r278r2mpgrsdliyv0h9hdkv8zha9vbal47hyyxy6pyi";
      };
      nvimSkipModule = oldAttrs.nvimSkipModule ++ [
        "snacks.picker.config.highlights"
        "snacks.picker.actions"
      ];
    });
  };
}
