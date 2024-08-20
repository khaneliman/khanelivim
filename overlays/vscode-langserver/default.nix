_: _final: prev: {
  # TODO: remove after https://github.com/NixOS/nixpkgs/pull/335559 is available in nixos-unstable
  vscode-langservers-extracted = prev.vscode-langservers-extracted.overrideAttrs {
    buildPhase =
      let
        extensions =
          if prev.stdenv.isDarwin then
            "../VSCodium.app/Contents/Resources/app/extensions"
          else
            "../resources/app/extensions";
      in
      ''
        npx babel ${extensions}/css-language-features/server/dist/node \
          --out-dir lib/css-language-server/node/
        npx babel ${extensions}/html-language-features/server/dist/node \
          --out-dir lib/html-language-server/node/
        npx babel ${extensions}/json-language-features/server/dist/node \
          --out-dir lib/json-language-server/node/
        cp -r ${prev.vscode-extensions.dbaeumer.vscode-eslint}/share/vscode/extensions/dbaeumer.vscode-eslint/server/out \
          lib/eslint-language-server
      '';
  };
}
