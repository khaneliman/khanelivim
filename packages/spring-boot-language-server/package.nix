{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spring-boot-language-server";
  version = "2.2.2026042300";

  src = fetchurl {
    url = "https://open-vsx.org/api/VMware/vscode-spring-boot/${finalAttrs.version}/file/VMware.vscode-spring-boot-${finalAttrs.version}.vsix";
    hash = "sha256-Cq9Vc0c5UNtXoe+/1mqroIO4w1t97DQN2NDxOjnCrh0=";
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
    runHook postInstall
  '';

  meta = {
    description = "Spring Boot language server and JDT LS extension jars from the VS Code Spring Boot Tools extension";
    homepage = "https://github.com/spring-projects/spring-tools";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.khaneliman ];
  };
})
