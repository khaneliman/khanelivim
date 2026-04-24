{
  lib,
  pkgs,
  config,
  ...
}:
{
  plugins = {
    lint = {
      # nvim-lint documentation
      # See: https://github.com/mfussenegger/nvim-lint
      enable = true;

      autoInstall = {
        enable = true;

        overrides = {
          swiftlint = lib.mkIf pkgs.stdenv.hostPlatform.isLinux null;
        };
      };

      lazyLoad.settings.event = "DeferredUIEnter";

      autoCmd = {
        event = [
          "BufReadPost"
          "BufWritePost"
          "InsertLeave"
          "TextChanged"
        ];
        callback.__raw = ''
          function()
            require("lint").try_lint()
          end
        '';
      };

      lintersByFt = {
        bash = [ "shellcheck" ];
        c = [ "clangtidy" ];
        cmake = [ "cmakelint" ];
        cpp = [ "clangtidy" ];
        # TODO:
        # cs = [ "sonarlint" ];
        css = lib.mkIf (!config.lsp.servers.stylelint_lsp.enable) [ "stylelint" ];
        fish = [ "fish" ];
        # TODO:
        # fsharp = [ "" ];
        gdscript = [ "gdlint" ];
        go = [ "golangcilint" ];
        html = [ "htmlhint" ];
        java = [ "checkstyle" ];
        javascript = lib.mkIf (!config.lsp.servers.biome.enable) [ "biomejs" ];
        javascriptreact = lib.mkIf (!config.lsp.servers.biome.enable) [ "biomejs" ];
        # FIXME: removed from nixpkgs find altnerative
        # json = [ "jsonlint" ];
        lua = [ "luacheck" ];
        make = [ "checkmake" ];
        gitcommit = [ "codespell" ];
        markdown = [
          "markdownlint-cli2"
          "codespell"
        ];
        nix = [
          "deadnix"
        ]
        ++ lib.optionals (!config.lsp.servers.statix.enable) [ "statix" ];
        python = lib.mkIf (!config.lsp.servers.ruff.enable) [ "ruff" ];
        sh = [ "shellcheck" ];
        sql = [ "sqlfluff" ];
        swift = [ "swiftlint" ];
        typescript = lib.mkIf (!config.lsp.servers.biome.enable) [ "biomejs" ];
        typescriptreact = lib.mkIf (!config.lsp.servers.biome.enable) [ "biomejs" ];
        # TODO:
        # xml = [ "xmllint" ];
        yaml = [ "yamllint" ];
        "yaml.ghaction" = [ "actionlint" ];
      };

    };
  };
}
