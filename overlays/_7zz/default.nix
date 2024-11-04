{
  useUasm ? false,
  ...
}:
_final: prev: {
  _7zz = prev._7zz.overrideAttrs (oldAttrs: {
    makeFlags =
      oldAttrs.makeFlags
      ++ prev.lib.optionals (!useUasm && prev.stdenv.hostPlatform.isx86) [ "USE_ASM=" ];
  });
}
