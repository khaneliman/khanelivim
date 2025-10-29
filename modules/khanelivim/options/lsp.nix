{ lib, ... }:
{
  options.khanelivim.lsp = {
    csharp = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "roslyn"
          "roslyn_ls"
        ]
      );
      default = "roslyn";
      description = "Which C# LSP to enable (mutually exclusive).";
    };
    cpp = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "clangd"
          "ccls"
        ]
      );
      default = "clangd";
      description = "Which C/C++ LSP to enable (mutually exclusive).";
    };
    docker = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "dockerls"
          "docker-language-server"
        ]
      );
      default = [
        "dockerls"
        "docker-language-server"
      ];
      description = "Which Docker LSPs to enable.";
    };
    java = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "nvim-jdtls"
          "java-language-server"
        ]
      );
      default = "nvim-jdtls";
      description = "Which Java LSP implementation to use.";
    };
    lua = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "lua-ls"
          "emmylua-ls"
        ]
      );
      default = "emmylua-ls";
      description = "Which Lua LSP to enable (mutually exclusive).";
    };
    nix = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "nixd"
          "nil-ls"
        ]
      );
      default = "nixd";
      description = "Which Nix LSP to enable (mutually exclusive).";
    };
    python = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "pyright"
          "pylsp"
          "basedpyright"
          "ruff"
        ]
      );
      default = [
        "pyright"
        "ruff"
      ];
      description = "Which Python LSPs to enable. Note: pylsp and basedpyright are mutually exclusive with pyright.";
    };
    typescript = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "typescript-tools"
          "ts_ls"
        ]
      );
      default = "typescript-tools";
      description = "Which TypeScript/JavaScript LSP integration to use.";
    };
    rust = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "rust-analyzer"
          "rustaceanvim"
        ]
      );
      default = "rust-analyzer";
      description = "Which Rust LSP integration to use (direct rust-analyzer or rustaceanvim).";
    };
  };
}
