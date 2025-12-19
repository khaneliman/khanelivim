{ lib, config, ... }:
{
  plugins = {
    grug-far = {
      enable = config.khanelivim.editor.search == "grug-far";
      lazyLoad = {
        settings = {
          cmd = "GrugFar";
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.grug-far.enable [
    {
      mode = "n";
      key = "<leader>rg";
      action = "<cmd>GrugFar<CR>";
      options = {
        desc = "GrugFar toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>rw";
      action.__raw = ''
        function()
          require('grug-far').open({
            prefills = {
              search = vim.fn.expand('<cword>'),
              paths = vim.fn.expand('%'),
            },
          })
        end
      '';
      options = {
        desc = "Rename word in buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>rW";
      action.__raw = ''
        function()
          require('grug-far').open({
            prefills = {
              search = vim.fn.expand('<cword>'),
            },
          })
        end
      '';
      options = {
        desc = "Rename word in project";
      };
    }
    {
      mode = "v";
      key = "<leader>rw";
      action.__raw = ''
        function()
          require('grug-far').open({
            prefills = {
              search = require('grug-far').get_current_visual_selection(),
              paths = vim.fn.expand('%'),
            },
          })
        end
      '';
      options = {
        desc = "Rename selection in buffer";
      };
    }
  ];
}
