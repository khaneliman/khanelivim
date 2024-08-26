{ config, pkgs, ... }:
let
  treesitter-fsharp-grammar = pkgs.tree-sitter.buildGrammar {
    language = "fsharp";
    version = "0.0.0+rev=f54ac4e";

    src = pkgs.fetchFromGitHub {
      owner = "ionide";
      repo = "tree-sitter-fsharp";
      rev = "f54ac4e66843b5af4887b586888e01086646b515";
      hash = "sha256-zKfMfue20B8sbS1tQKZAlokRV7efMsxBk7ySQmzLo0Y=";
    };

    fixupPhase = ''
      mkdir -p $out/queries/fsharp
      mv $out/queries/*.scm $out/queries/fsharp/
    '';

    meta.homepage = "https://github.com/ionide/tree-sitter-fsharp";
  };
in
{
  extraPlugins = [ treesitter-fsharp-grammar ];

  plugins = {
    treesitter = {
      enable = true;

      folding = true;
      grammarPackages = config.plugins.treesitter.package.passthru.allGrammars ++ [
        treesitter-fsharp-grammar
      ];
      nixvimInjections = true;

      settings = {
        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
          disable = # Lua
            ''
              function(lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 10000
              end
            '';
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };

        indent = {
          enable = true;
        };
      };
    };

    treesitter-refactor = {
      enable = true;

      highlightDefinitions = {
        enable = true;
        clearOnCursorMove = true;
      };
      smartRename = {
        enable = true;
      };
      navigation = {
        enable = true;
      };
    };
  };
}
