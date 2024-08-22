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
      nixvimInjections = true;

      settings = {
        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
          disable = # lua
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

      grammarPackages = config.plugins.treesitter.package.passthru.allGrammars ++ [
        treesitter-fsharp-grammar
      ];

      # NOTE: Default is to install all grammars, here's a more concise list of ones i care about
      # grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      #   angular
      #   bash
      #   bicep
      #   c
      #   c-sharp
      #   cmake
      #   cpp
      #   css
      #   csv
      #   diff
      #   dockerfile
      #   dot
      #   fish
      #   git_config
      #   git_rebase
      #   gitattributes
      #   gitcommit
      #   gitignore
      #   go
      #   html
      #   hyprlang
      #   java
      #   javascript
      #   json
      #   json5
      #   jsonc
      #   kdl
      #   latex
      #   lua
      #   make
      #   markdown
      #   markdown_inline
      #   mermaid
      #   meson
      #   ninja
      #   nix
      #   norg
      #   objc
      #   python
      #   rasi
      #   readline
      #   regex
      #   rust
      #   scss
      #   sql
      #   ssh-config
      #   svelte
      #   swift
      #   terraform
      #   toml
      #   tsx
      #   typescript
      #   vim
      #   vimdoc
      #   xml
      #   yaml
      #   zig
      # ];
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
