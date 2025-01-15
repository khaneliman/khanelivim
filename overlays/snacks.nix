_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = "2025-01-15";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "076259d263c927ed1d1c56c94b6e870230e77a3d";
        sha256 = "1fn9129j1vdsmq8qjri77230lx8bvjpi4kck0v90dfcg2rwaq39g";
      };
      nvimSkipModule = oldAttrs.nvimSkipModule ++ [
        "snacks.picker.config.highlights"
        "snacks.picker.actions"
      ];
    });
  };
}
