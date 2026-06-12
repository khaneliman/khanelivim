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
      enable = lib.mkDefault true;

      autoInstall = {
        enable = lib.mkDefault true;

        overrides = {
          xmllint = pkgs.libxml2;
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
          function(args)
            -- Octo comment/body buffers use the compound filetype "markdown.gh",
            -- which nvim-lint resolves down to the markdown linters. Skip any
            -- buffer carrying the "gh" filetype component.
            for _, sub_ft in ipairs(vim.split(vim.bo[args.buf].filetype, ".", { plain = true })) do
              if sub_ft == "gh" then
                return
              end
            end
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
        json = [ "jq" ];
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
        xml = [ "xmllint" ];
        yaml = [ "yamllint" ];
        "yaml.ghaction" = [ "actionlint" ];
      };

      customLinters.xmllint = {
        cmd = "xmllint";
        args = [
          "--noout"
          "-"
        ];
        stdin = true;
        stream = "stderr";
        ignore_exitcode = true;
        parser = ''
          require('lint.parser').from_pattern(
            '^.-:(%d+): parser error : (.*)$',
            { 'lnum', 'message' },
            nil,
            { source = 'xmllint', severity = vim.diagnostic.severity.ERROR },
            { lnum_offset = -1 }
          )
        '';
      };

    };
  };
}
