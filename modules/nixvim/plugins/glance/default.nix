{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    glance = {
      # glance.nvim documentation
      # See: https://github.com/DNLHC/glance.nvim
      enable = config.khanelivim.lsp.navigation == "glance";
      package = pkgs.vimPlugins.glance-nvim.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./escape-statusline.patch
          ./neovim-0.13-islist.patch
        ];
      });

      lazyLoad.settings.cmd = "Glance";

      settings = {
        border.enable = true;
      };
    };

  };

  keymaps = lib.mkIf config.plugins.glance.enable [
    {
      action = "<CMD>Glance definitions<CR>";
      mode = "n";
      key = "<leader>ld";
      options = {
        desc = "Glance definition";
      };
    }
    {
      action = "<CMD>Glance implementations<CR>";
      mode = "n";
      key = "<leader>li";
      options = {
        desc = "Glance implementation";
      };
    }
    {
      action = "<CMD>Glance references<CR>";
      mode = "n";
      key = "<leader>lD";
      options = {
        desc = "Glance reference";
      };
    }
    {
      action = "<CMD>Glance type_definitions<CR>";
      mode = "n";
      key = "<leader>lt";
      options = {
        desc = "Glance type definition";
      };
    }
  ];
}
