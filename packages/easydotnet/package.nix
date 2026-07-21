{
  buildDotnetGlobalTool,
  lib,
  pkgs,
}:

let
  version = "3.4.11";
  nugetName = "EasyDotnet";
  hostRid = pkgs.dotnetCorePackages.systemToDotnetRid pkgs.stdenv.hostPlatform.system;

  package = buildDotnetGlobalTool {
    pname = "easydotnet";
    inherit version nugetName;
    executables = "dotnet-easydotnet";

    nugetHash = "sha256-hD1/5fPgGrrpFldvzYyIVScIQCDJzMeStcu2WK+Sfas=";

    meta = {
      description = "Server CLI for easy-dotnet.nvim";
      homepage = "https://github.com/GustavEikaas/easy-dotnet-server";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.khaneliman ];
      mainProgram = "dotnet-easydotnet";
    };
  };
in
package.overrideAttrs (old: {
  buildInputs = [
    (old.passthru.nupkg.overrideAttrs (_: {
      preFixup = ''
        dncdbg="$out/share/nuget/packages/${lib.toLower nugetName}/${lib.toLower version}/tools/dncdbg"

        find "$dncdbg" -type f -name '*.dbg' -delete
        find "$dncdbg" -mindepth 1 -maxdepth 1 ! -name '${hostRid}' -exec rm -rf {} +

        patch-nupkgs "$out/share/nuget/packages"
      '';
    }))
  ];
})
