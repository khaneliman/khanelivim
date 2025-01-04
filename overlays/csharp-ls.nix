_: _self: super: {
  csharp-ls = super.csharp-ls.overrideAttrs {
    meta.badPlatforms = [ ];
  };
}
