{
  buildDotnetGlobalTool,
  lib,
}:

buildDotnetGlobalTool {
  pname = "easydotnet";
  version = "3.2.9";
  nugetName = "EasyDotnet";
  executables = "dotnet-easydotnet";

  nugetHash = "sha256-ndR+otKkL66lqWw2O6Je9iKUOFqKPRqzk2qfDChSULY=";

  meta = {
    description = "Server CLI for easy-dotnet.nvim";
    homepage = "https://github.com/GustavEikaas/easy-dotnet-server";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.khaneliman ];
    mainProgram = "dotnet-easydotnet";
  };
}
