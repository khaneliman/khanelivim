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
          "tree-sitter-cuda"
          "tree-sitter-d"
          "tree-sitter-fortran"
          "tree-sitter-gnuplot"
          "tree-sitter-haskell"
          "tree-sitter-hlsl"
          "tree-sitter-julia"
          "tree-sitter-koto"
          "tree-sitter-lean"
          "tree-sitter-nim"
          "tree-sitter-razor"
          "tree-sitter-scala"
          "tree-sitter-slang"
          "tree-sitter-systemverilog"
          "tree-sitter-tlaplus"
          "tree-sitter-verilog"
        ];
        description = "List of treesitter grammars to exclude from the installation to save space.";
      };
    };
  };
}
