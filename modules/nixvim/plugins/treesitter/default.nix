{
  config,
  lib,
  ...
}:
{

  # Home manager injections
  extraFiles = lib.mkIf config.plugins.treesitter.nixvimInjections {
    "after/queries/nix/injections.scm".source = ./injections-hm.scm;
  };

  plugins = {
    treesitter = {
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
