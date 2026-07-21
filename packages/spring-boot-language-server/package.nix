{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spring-boot-language-server";
  version = "2.3.2026072100";

  src = fetchurl {
    url = "https://open-vsx.org/api/VMware/vscode-spring-boot/${finalAttrs.version}/file/VMware.vscode-spring-boot-${finalAttrs.version}.vsix";
    hash = "sha256-TqJL9sM2/BU7rZJ8QTR/Eg2lmtco7/pfzBIAcjxqk9c=";
  };

  nativeBuildInputs = [
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip "$src" -d source
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r source/extension/language-server "$out/language-server"
    cp -r source/extension/jars "$out/jars"

    serverJar="$(
      find "$out/language-server" -maxdepth 1 -type f \
        -name 'spring-boot-language-server-*-exec.jar' -print -quit
    )"
    test -n "$serverJar"
    ln -s "$(basename "$serverJar")" "$out/language-server/spring-boot-language-server.jar"

    runHook postInstall
  '';

  meta = {
    description = "Spring Boot language server and JDT LS extension jars from the VS Code Spring Boot Tools extension";
    homepage = "https://github.com/spring-projects/spring-tools";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.khaneliman ];
  };
})
