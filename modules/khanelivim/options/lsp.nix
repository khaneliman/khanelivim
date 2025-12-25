{ lib, ... }:
{
  options.khanelivim.lsp = {
    # keep-sorted start block=yes newline_separated=yes
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
      default = "nil-ls";
      description = "Which Nix LSP to enable (mutually exclusive).";
    };

    python = {
      typeChecker = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "pyright"
            "pylsp"
            "basedpyright"
          ]
        );
        default = "pyright";
        description = "Which Python type checker to use (mutually exclusive).";
      };

      linters = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "ruff"
          ]
        );
        default = [ "ruff" ];
        description = "Python linters and formatters to enable alongside the type checker.";
      };
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
    # keep-sorted end
  };
}
