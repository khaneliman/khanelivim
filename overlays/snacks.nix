_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (oldAttrs: {
      version = "2025-01-17";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "706b1abc1697ca050314dc667e0900d53cad8aa4";
        sha256 = "sha256-yqdHNqBu0KByIhmCD/Gnt6T+CQ6H/iUT7X/kPoJ0esM=";
      };
      nvimSkipModule = oldAttrs.nvimSkipModule ++ [
        "snacks.picker.config.highlights"
        "snacks.picker.actions"
        "snacks.picker.util.db"
      ];
    });
  };
}
