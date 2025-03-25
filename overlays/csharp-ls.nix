_: _final: prev: {
  csharp-ls = prev.csharp-ls.overrideAttrs {
    meta.badPlatforms = [ ];
  };
}
