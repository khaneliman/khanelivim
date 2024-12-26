_: _final: prev: {
  lua-language-server = prev.lua-language-server.overrideAttrs (_oldAttrs: {
    buildInputs =
      [
        prev.fmt
      ]
      ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [
        prev.rsync
      ];

    env.NIX_LDFLAGS = "-lfmt";

    postPatch =
      ''
        # filewatch tests are failing on darwin
        # this feature is not used in lua-language-server
        substituteInPlace 3rd/bee.lua/test/test.lua \
          --replace-fail 'require "test_filewatch"' ""

        # use nixpkgs fmt library
        for d in 3rd/bee.lua 3rd/luamake/bee.lua
        do
          rm -r $d/3rd/fmt/*
          touch $d/3rd/fmt/format.cc
          substituteInPlace $d/bee/nonstd/format.h $d/bee/nonstd/print.h \
            --replace-fail "include <3rd/fmt/fmt" "include <fmt"
        done

        # flaky tests on linux
        # https://github.com/LuaLS/lua-language-server/issues/2926
        substituteInPlace test/tclient/init.lua \
          --replace-fail "require 'tclient.tests.load-relative-library'" ""

        pushd 3rd/luamake
      ''
      + prev.lib.optionalString prev.stdenv.hostPlatform.isDarwin (
        # This package uses the program clang for C and C++ files. The language
        # is selected via the command line argument -std, but this do not work
        # in combination with the nixpkgs clang wrapper. Therefor we have to
        # find all c++ compiler statements and replace $cc (which expands to
        # clang) with clang++.
        ''
          sed -i compile/ninja/macos.ninja \
            -e '/c++/s,$cc,clang++,' \
            -e '/test.lua/s,= .*,= true,' \
            -e '/ldl/s,$cc,clang++,'
          sed -i scripts/compiler/gcc.lua \
            -e '/cxx_/s,$cc,clang++,'
        ''
        # Avoid relying on ditto (impure)
        + ''
          substituteInPlace compile/ninja/macos.ninja \
            --replace-fail "ditto" "rsync -a"

          substituteInPlace scripts/writer.lua \
            --replace-fail "ditto" "rsync -a"
        ''
      );
  });
}
