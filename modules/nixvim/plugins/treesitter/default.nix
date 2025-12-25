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

      grammarPackages = lib.filter (
        g: !(lib.elem g.pname config.khanelivim.performance.treesitter.excludedGrammars)
      ) config.plugins.treesitter.package.allGrammars;
      nixvimInjections = true;

      settings = {
        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
          disable = /* Lua */ ''
            function(lang, bufnr)
              return vim.api.nvim_buf_line_count(bufnr) > 10000
            end
          '';
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<A-o>";
            node_incremental = "<A-o>";
            scope_incremental = "<A-O>";
            node_decremental = "<A-i>";
          };
        };

        indent = {
          enable = true;
        };
      };
    };
  };
}
