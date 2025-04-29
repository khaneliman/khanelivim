{ lib, pkgs, ... }:
{
  lsp.servers.clangd = {
    enable = true;

    config = {
      settings.init_options = {
        usePlaceholders = true;
        completeUnimported = true;
        clangdFileStatus = true;
      };
      cmd = [
        "${lib.getExe' pkgs.clang-tools "clangd"}"
        "--background-index"
        "--clang-tidy"
        "--header-insertion=iwyu"
        "--completion-style=detailed"
        "--function-arg-placeholders"
        "--fallback-style=llvm"
      ];
    };
  };
}
