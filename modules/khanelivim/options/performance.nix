{ lib, ... }:
{
  options.khanelivim.performance = {
    optimizer = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.listOf (
          lib.types.enum [
            "faster"
            "snacks"
          ]
        )
      );
      default = [ "faster" ];
      description = "Performance optimization strategies for large files (can use multiple)";
    };

    optimizeEnable =
      lib.mkEnableOption "nixvim performance optimizations (byte compilation, plugin combining)"
      // {
        default = true;
      };

    disabledPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "gzip"
        "matchit"
        "matchparen"
        "netrwPlugin"
        "rplugin"
        "tarPlugin"
        "tohtml"
        "tutor"
        "zipPlugin"
      ];
      description = "Built-in Neovim plugins to disable for faster startup";
    };

    treesitter = {
      whitelistMode = lib.mkEnableOption "whitelist mode for treesitter grammars (only install specified grammars)";

      includedGrammars = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "tree-sitter-angular"
          "tree-sitter-bash"
          "tree-sitter-c"
          "tree-sitter-css"
          "tree-sitter-diff"
          "tree-sitter-dockerfile"
          "tree-sitter-git_config"
          "tree-sitter-git_rebase"
          "tree-sitter-gitattributes"
          "tree-sitter-gitcommit"
          "tree-sitter-gitignore"
          "tree-sitter-go"
          "tree-sitter-gomod"
          "tree-sitter-gosum"
          "tree-sitter-helm"
          "tree-sitter-html"
          "tree-sitter-http"
          "tree-sitter-ini"
          "tree-sitter-java"
          "tree-sitter-javascript"
          "tree-sitter-json"
          "tree-sitter-just"
          "tree-sitter-kdl"
          "tree-sitter-lua"
          "tree-sitter-make"
          "tree-sitter-markdown"
          "tree-sitter-markdown_inline"
          "tree-sitter-mermaid"
          "tree-sitter-nginx"
          "tree-sitter-nix"
          "tree-sitter-php"
          "tree-sitter-python"
          "tree-sitter-query"
          "tree-sitter-regex"
          "tree-sitter-rust"
          "tree-sitter-scss"
          "tree-sitter-terraform"
          "tree-sitter-toml"
          "tree-sitter-tsx"
          "tree-sitter-typescript"
          "tree-sitter-vim"
          "tree-sitter-vimdoc"
          "tree-sitter-xml"
          "tree-sitter-yaml"
        ];
        description = "List of treesitter grammars to explicitly include when whitelistMode is enabled.";
      };

      excludedGrammars = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          # Size
          "tree-sitter-agda"
          "tree-sitter-apex"
          "tree-sitter-arduino"
          "tree-sitter-blade"
          "tree-sitter-c3"
          "tree-sitter-cuda"
          "tree-sitter-d"
          "tree-sitter-elixir"
          "tree-sitter-fortran"
          "tree-sitter-gnuplot"
          "tree-sitter-hack"
          "tree-sitter-haskell"
          "tree-sitter-hlsl"
          "tree-sitter-hoon"
          "tree-sitter-idris"
          "tree-sitter-ispc"
          "tree-sitter-julia"
          "tree-sitter-kotlin"
          "tree-sitter-koto"
          "tree-sitter-latex"
          "tree-sitter-lean"
          "tree-sitter-nim"
          "tree-sitter-ocaml"
          "tree-sitter-ocaml_interface"
          "tree-sitter-odin"
          "tree-sitter-perl"
          "tree-sitter-purescript"
          "tree-sitter-qmljs"
          "tree-sitter-razor"
          "tree-sitter-ruby"
          "tree-sitter-scala"
          "tree-sitter-slang"
          "tree-sitter-systemverilog"
          "tree-sitter-tlaplus"
          "tree-sitter-unison"
          "tree-sitter-v"
          "tree-sitter-verilog"
          "tree-sitter-vhdl"

          # Never going to use

        ];
        description = "List of treesitter grammars to exclude from the installation to save space.";
      };
    };
  };
}
