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
      ]
      ++ [
        (lib.nixvim.mkRaw ''vim.fn.stdpath("cache") .. "/roslyn_ls/logs"'')
      ]
      ++ [
        "--stdio"
      ];
    };
  };
}
