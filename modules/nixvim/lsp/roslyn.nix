{ lib, pkgs, ... }:
{
  lsp.servers.roslyn_ls = {
    enable = true;

    settings = {
      cmd = [
        "${lib.getExe' pkgs.roslyn-ls "Microsoft.CodeAnalysis.LanguageServer"}"
        "--logLevel"
        "Information"
        "--extensionLogDirectory"
        "fs.joinpath(uv.os_tmpdir() \"roslyn_ls/logs\")"
        "--stdio"
      ];
    };
  };
}
