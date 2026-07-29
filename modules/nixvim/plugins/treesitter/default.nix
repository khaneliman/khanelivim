{
  config,
  lib,
  ...
}:
let
  injectionQueryDir = ./queries/nix/injections;
  injectionQueryFiles =
    path:
    builtins.attrNames (
      lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".scm" name) (builtins.readDir path)
    );
  injectionQuery =
    path:
    lib.concatStringsSep "\n\n" (
      map (name: builtins.readFile (path + "/${name}")) (injectionQueryFiles path)
    );
in
{

  # Nix injections
  extraFiles = lib.mkIf config.plugins.treesitter.enable {
    "queries/nix/injections.scm".text = injectionQuery injectionQueryDir;
  };

  plugins = {
    treesitter = {
      # nvim-treesitter documentation
      # See: https://github.com/nvim-treesitter/nvim-treesitter
      enable = lib.mkDefault true;

      folding.enable = true;
      highlight.enable = true;
      indent.enable = true;

      grammarPackages =
        let
          whitelistMode = config.khanelivim.performance.treesitter.whitelistMode;
          grammarSet = lib.genAttrs (
            if whitelistMode then
              config.khanelivim.performance.treesitter.includedGrammars
            else
              config.khanelivim.performance.treesitter.excludedGrammars
          ) (_: true);
          grammarIsSelected = g: grammarSet.${g.pname} or false;
        in
        lib.filter (
          if whitelistMode then grammarIsSelected else g: !grammarIsSelected g
        ) config.plugins.treesitter.package.allGrammars;
      nixvimInjections = lib.mkForce false;
    };
  };

  keymaps = lib.mkIf config.plugins.treesitter.enable [
    {
      mode = [
        "n"
        "x"
      ];
      key = "<A-o>";
      action.__raw = ''
        function()
          if vim.treesitter.get_parser(nil, nil, { error = false }) then
            vim.treesitter.select("parent", vim.v.count1)
          else
            vim.lsp.buf.selection_range(vim.v.count1)
          end
        end
      '';
      options.desc = "Expand syntax selection";
    }
    {
      mode = "x";
      key = "<A-i>";
      action.__raw = ''
        function()
          if vim.treesitter.get_parser(nil, nil, { error = false }) then
            vim.treesitter.select("child", vim.v.count1)
          else
            vim.lsp.buf.selection_range(-vim.v.count1)
          end
        end
      '';
      options.desc = "Shrink syntax selection";
    }
  ];
}
