{
  config,
  lib,
  ...
}:
let
  injectionQueryDir = ./queries/nix/injections;
  injectionQueryFiles =
    path:
    lib.filter (name: lib.hasSuffix ".scm" name) (
      builtins.attrNames (lib.filterAttrs (_: type: type == "regular") (builtins.readDir path))
    );
  injectionQuery =
    path:
    lib.concatStringsSep "\n\n" (
      map (name: builtins.readFile (path + "/${name}")) (injectionQueryFiles path)
    );
in
{

  # Nix injections
  extraFiles = lib.mkIf config.plugins.treesitter.nixvimInjections {
    "after/queries/nix/injections.scm".text = injectionQuery injectionQueryDir;
  };

  plugins = {
    treesitter = {
      # nvim-treesitter documentation
      # See: https://github.com/nvim-treesitter/nvim-treesitter
      enable = true;

      folding.enable = true;
      highlight.enable = true;
      indent.enable = true;

      grammarPackages =
        if config.khanelivim.performance.treesitter.whitelistMode then
          lib.filter (
            g: lib.elem g.pname config.khanelivim.performance.treesitter.includedGrammars
          ) config.plugins.treesitter.package.allGrammars
        else
          lib.filter (
            g: !(lib.elem g.pname config.khanelivim.performance.treesitter.excludedGrammars)
          ) config.plugins.treesitter.package.allGrammars;
      nixvimInjections = true;
    };
  };
}
