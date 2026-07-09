{ flake }:
_final: prev: {
  neovim-unwrapped =
    flake.inputs.neovim-nightly-overlay.packages.${prev.stdenv.system}.default.overrideAttrs
      (
        old:
        prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace test/functional/testnvim.lua \
              --replace-fail \
                "table.insert(args, _G._nvim_test_id)" \
                "table.insert(args, './' .. _G._nvim_test_id)"
          '';
        }
      );
}
