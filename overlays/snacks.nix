_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = "2025-01-16";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "71f69e5e57f355f40251e274d45560af7d8dd365";
        sha256 = "sha256-F1BCQ3UJoVeCeUY747yN75Wadtj2kSlyq/2hb2sx/pY=";
      };
      nvimSkipModule = oldAttrs.nvimSkipModule ++ [
        "snacks.picker.config.highlights"
        "snacks.picker.actions"
        "snacks.picker.util.db"
      ];
    });
  };
}
