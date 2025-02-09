_: _self: super: {
  luajitPackages = super.luajitPackages // {
    neotest = super.luajitPackages.neotest.overrideAttrs {
      meta.broken = false;
    };
  };
}
