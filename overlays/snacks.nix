_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = "2025-01-16";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "33e1e1689f08a4ffde924e97093c46387b349560";
        sha256 = "sha256-uDjDPSs4bDNBhrX7yVLuk6GoqmCK7E5q0X7B2NAReH8=";
      };
      nvimSkipModule = oldAttrs.nvimSkipModule ++ [
        "snacks.picker.config.highlights"
        "snacks.picker.actions"
      ];
    });
  };
}
