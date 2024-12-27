_: _final: prev: {
  csharp-ls = prev.csharp-ls.overrideAttrs (_oldAttrs: {
    meta.badPlatforms = [ ];
  });
}
