_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    trouble-nvim = prev.vimPlugins.trouble-nvim.overrideAttrs {
      version = "2025-01-15";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "trouble.nvim";
        rev = "50481f414bd3c1a40122c1d759d7e424d5fafe84";
        sha256 = "14cvhnz4njzqydnbyf9iydsdhqvms4kajlvxgkr1gfkw6rw96r37";
      };
    };
  };
}
