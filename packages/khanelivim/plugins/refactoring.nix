{ config, lib, ... }:
{
  plugins = {
    refactoring = {
      enable = true;
      enableTelescope = true;
    };

    which-key.settings.spec = lib.optionals config.plugins.refactoring.enable [
      {
        __unkeyed = "<leader>r";
        mode = "x";
        group = "Refactor";
        icon = " ";
      }
    ];
  };

  keymaps =
    lib.optionals config.plugins.refactoring.enable [
      {
        mode = "x";
        key = "<leader>re";
        action = "<cmd>Refactor extract<cr>";
        options = {
          desc = "Extract";
        };
      }
      {
        mode = "x";
        key = "<leader>rE";
        action = "<cmd>Refactor extract_to_file<cr>";
        options = {
          desc = "Extract to file";
        };
      }
      {
        mode = "x";
        key = "<leader>rv";
        action = "cmd>Refactor extract_var<cr>";
        options = {
          desc = "Extract var";
        };
      }
      {
        mode = "n";
        key = "<leader>ri";
        action = "<cmd>Refactor inline_var<CR>";
        options = {
          desc = "Inline var";
        };
      }
      {
        mode = "n";
        key = "<leader>rI";
        action = "<cmd>Refactor inline_func<CR>";
        options = {
          desc = "Inline Func";
        };
      }
      {
        mode = "n";
        key = "<leader>rb";
        action = "<cmd>Refactor extract_block<CR>";
        options = {
          desc = "Extract block";
        };
      }
      {
        mode = "n";
        key = "<leader>rB";
        action = "<cmd>Refactor extract_block_to_file<CR>";
        options = {
          desc = "Extract block to file";
        };
      }
    ]
    ++ lib.optionals (config.plugins.telescope.enable && config.plugins.refactoring.enable) [
      {
        mode = "n";
        key = "<leader>fR";
        action.__raw = ''
          function()
            require('telescope').extensions.refactoring.refactors()
          end
        '';
        options = {
          desc = "Refactoring";
          silent = true;
        };
      }
    ];
}
