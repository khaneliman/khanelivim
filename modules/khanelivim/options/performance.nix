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
      excludedGrammars = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
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
        ];
        description = "List of treesitter grammars to exclude from the installation to save space.";
      };
    };
  };
}
