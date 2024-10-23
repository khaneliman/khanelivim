_: _final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      # Fix byte index encoding bounds.
      # - https://github.com/neovim/neovim/pull/30747
      # - https://github.com/nix-community/nixvim/issues/2390
      (prev.fetchpatch {
        name = "fix-lsp-str_byteindex_enc-bounds-checking-30747.patch";
        url = "https://patch-diff.githubusercontent.com/raw/neovim/neovim/pull/30747.patch";
        hash = "sha256-2oNHUQozXKrHvKxt7R07T9YRIIx8W3gt8cVHLm2gYhg=";
      })
    ];
  });
}
