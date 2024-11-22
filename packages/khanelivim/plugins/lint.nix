{ lib, pkgs, ... }:
{
  plugins = {
    lint = {
      enable = true;
      lintersByFt = {
        bash = [
          "bash"
          "shellcheck"
        ];
        bicep = [ "bicep" ];
        c = [ "clangtidy" ];
        cmake = [ "cmakelint" ];
        cpp = [ "clangtidy" ];
        # TODO:
        # cs = [ "sonarlint" ];
        css = [ "stylelint" ];
        fish = [ "fish" ];
        # TODO:
        # fsharp = [ "" ];
        gdscript = [ "gdlint" ];
        go = [ "golangcilint" ];
        html = [ "htmlhint" ];
        java = [ "checkstyle" ];
        javascript = [ "biomejs" ];
        json = [ "jsonlint" ];
        lua = [ "luacheck" ];
        make = [ "checkmake" ];
        markdown = [ "markdownlint" ];
        nix = [
          "deadnix"
          "nix"
          "statix"
        ];
        python = [
          "pylint"
          "ruff"
        ];
        rust = [ "clippy" ];
        sh = [
          "shellcheck"
          "shellharden"
        ];
        sql = [ "sqlfluff" ];
        swift = [ "swiftlint" ];
        # TODO:
        # terraform = [ ];
        # toml = [ "taplo" ];
        typescript = [ "biomejs" ];
        # xml = [ "xmllint" ];
        yaml = [ "yamllint" ];
      };

      linters = {
        biomejs = {
          cmd = lib.getExe pkgs.biome;
        };
        checkmake = {
          cmd = lib.getExe pkgs.checkmake;
        };
        checkstyle = {
          cmd = lib.getExe pkgs.checkstyle;
        };
        clippy = {
          cmd = lib.getExe pkgs.rust-analyzer;
        };
        deadnix = {
          cmd = lib.getExe pkgs.deadnix;
        };
        fish = {
          cmd = lib.getExe pkgs.fish;
        };
        gdlint = {
          cmd = lib.getExe' pkgs.gdtoolkit_4 "gdlint";
        };
        golangcilint = {
          cmd = lib.getExe pkgs.golangci-lint;
        };
        htmlhint = {
          cmd = lib.getExe pkgs.htmlhint;
        };
        jsonlint = {
          cmd = lib.getExe pkgs.nodePackages.jsonlint;
        };
        luacheck = {
          cmd = lib.getExe pkgs.luaPackages.luacheck;
        };
        markdownlint = {
          cmd = lib.getExe pkgs.markdownlint-cli;
        };
        pylint = {
          cmd = lib.getExe pkgs.pylint;
        };
        ruff = {
          cmd = lib.getExe pkgs.ruff;
        };
        shellcheck = {
          cmd = lib.getExe pkgs.shellcheck;
        };
        sqlfluff = {
          cmd = lib.getExe pkgs.sqlfluff;
        };
        statix = {
          cmd = lib.getExe pkgs.statix;
        };
        swiftlint = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          cmd = lib.getExe pkgs.swiftlint;
        };
        yamllint = {
          cmd = lib.getExe pkgs.yamllint;
        };
      };
    };
  };
}
