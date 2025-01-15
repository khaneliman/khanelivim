{ config, lib, ... }:
{
  autoCmd = lib.optionals config.plugins.neorg.enable [
    {
      event = "FileType";
      pattern = "norg";
      command = "setlocal conceallevel=1";
    }
    {
      event = "BufWritePre";
      pattern = "*.norg";
      command = "normal gg=G``zz";
    }
  ];

  plugins.neorg = {
    enable = true;
    telescopeIntegration.enable = config.plugins.telescope.enable;

    lazyLoad.settings = {
      cmd = "Neorg";
      ft = "norg";
    };

    settings = {
      lazy_loading = true;

      load = {
        "core.defaults" = lib.mkIf config.plugins.treesitter.enable { __empty = null; };

        "core.keybinds".config.hook.__raw = ''
          function(keybinds)
            keybinds.unmap('norg', 'n', '<C-s>')

            keybinds.map(
              'norg',
              'n',
              '<leader>c',
              ':Neorg toggle-concealer<CR>',
              {silent=true}
            )
          end
        '';

        "core.dirman".config.workspaces = {
          notes = "~/notes";
          nix = "~/perso/nix/notes";
        };

        "core.concealer".__empty = null;
        "core.completion".config.engine = "nvim-cmp";
      };
    };
  };
}
