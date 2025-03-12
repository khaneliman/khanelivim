_: _self: super: {
  luajit_2_1 = super.luajit_2_1.overrideAttrs {
    version = "2.1.1741730670";
    src = super.fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "538a82133ad6fddfd0ca64de167c4aca3bc1a2da";
      hash = "sha256-3DhNqVdojsWDo8mKJXIyTqFODIiKzThcAzHPdnoJaVM=";
    };
  };
  luajit_2_0 = super.luajit_2_0.overrideAttrs {
    version = "2.0.1741557863";
    src = super.fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "85c3f2fb6f59276ebf07312859a69d6d5a897f62";
      hash = "sha256-5UIZ650M/0W08iX1ajaHvDbNgjbzZJ1akVwNbiDUeyY=";
    };
  };
}
