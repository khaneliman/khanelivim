{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs_22,
}:

buildNpmPackage (finalAttrs: {
  pname = "kulala-ls";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DSpQ38wQ7uRxbJwPUVtFLrlc8gur/0MHzLc1itCsOR0=";
  };

  patches = [
    # The upstream lockfile is not universal. It is missing Rollup's optional
    # platform packages, which makes `npm ci` fail before dependency omission
    # flags can take effect.
    ./fix-package-lock.patch
    # Generated parser sources are already included. Keeping tree-sitter-cli
    # causes an install-time network download for a prebuilt CLI binary.
    ./remove-tree-sitter-cli.patch
  ];

  nodejs = nodejs_22;
  npmDepsHash = "sha256-PcJqapA5fhzrDixnXQ5StwTNasXTdqyEnErd3G7iiYg=";
  npmDepsFetcherVersion = 2;

  buildPhase = ''
    runHook preBuild
    npm run build:server
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    package="$out/lib/node_modules/@mistweaverco/kulala-ls"
    mkdir -p "$package" "$out/bin"

    cp pkg/server/{package.json,README.md,cli.cjs} "$package/"
    chmod +x "$package/cli.cjs"
    cp -r node_modules "$package/node_modules"

    rm -rf "$package/node_modules/@mistweaverco/kulala-ls"
    rm -rf "$package/node_modules/@mistweaverco/tree-sitter-kulala"
    rm -rf "$package/node_modules/@mistweaverco/tree-sitter-graphql"
    rm -f "$package/node_modules/.bin/kulala-ls"

    mkdir -p "$package/node_modules/@mistweaverco"
    cp -r pkg/tree-sitter "$package/node_modules/@mistweaverco/tree-sitter-kulala"
    cp -r pkg/tree-sitter-graphql "$package/node_modules/@mistweaverco/tree-sitter-graphql"

    ln -s "$package/cli.cjs" "$out/bin/kulala-ls"

    runHook postInstall
  '';

  meta = {
    description = "Minimal language server for HTTP syntax";
    homepage = "https://github.com/mistweaverco/kulala-ls";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.khaneliman ];
    mainProgram = "kulala-ls";
  };
})
