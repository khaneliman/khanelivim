{ config, lib, ... }:
{
  plugins = {
    refactoring = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;

      settings = {
        # Prompt for return types in languages that support it
        prompt_func_return_type = {
          go = true;
          cpp = true;
          c = true;
          java = true;
        };

        # Prompt for function parameter types
        prompt_func_param_type = {
          go = true;
          cpp = true;
          c = true;
          java = true;
        };
      };

      lazyLoad = {
        settings = {
          before = lib.mkIf (config.plugins.telescope.enable && config.plugins.lz-n.enable) {
            __raw = ''
              require('lz.n').trigger_load('telescope')
            '';
          };
          cmd = "Refactor";
          keys = lib.mkIf config.plugins.telescope.enable [
            {
              __unkeyed-1 = "<leader>fR";
              __unkeyed-2.__raw = ''
                function()
                  require('telescope').extensions.refactoring.refactors()
                end
              '';
              desc = "Refactoring";
            }
          ];
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.refactoring.enable [
      {
        __unkeyed-1 = "<leader>r";
        mode = [
          "n"
          "x"
        ];
        group = "Refactor";
        icon = " ";
      }
    ];
  };

  keymaps =
    lib.optionals config.plugins.refactoring.enable [
      # Extract operations (visual mode)
      {
        mode = "x";
        key = "<leader>re";
        action = "<cmd>Refactor extract<cr>";
        options = {
          desc = "Extract Function";
        };
      }
      {
        mode = "x";
        key = "<leader>rE";
        action = "<cmd>Refactor extract_to_file<cr>";
        options = {
          desc = "Extract Function to File";
        };
      }
      {
        mode = "x";
        key = "<leader>rv";
        action = "<cmd>Refactor extract_var<cr>";
        options = {
          desc = "Extract Variable";
        };
      }

      # Inline operations (normal mode)
      {
        mode = "n";
        key = "<leader>ri";
        action = "<cmd>Refactor inline_var<CR>";
        options = {
          desc = "Inline Variable";
        };
      }
      {
        mode = "n";
        key = "<leader>rI";
        action = "<cmd>Refactor inline_func<CR>";
        options = {
          desc = "Inline Function";
        };
      }

      # Block operations (normal mode)
      {
        mode = "n";
        key = "<leader>rb";
        action = "<cmd>Refactor extract_block<CR>";
        options = {
          desc = "Extract Block";
        };
      }
      {
        mode = "n";
        key = "<leader>rB";
        action = "<cmd>Refactor extract_block_to_file<CR>";
        options = {
          desc = "Extract Block to File";
        };
      }

      # Debug operations (based on documentation)
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>rp";
        action.__raw = ''
          function()
            require('refactoring').debug.printf({below = false})
          end
        '';
        options = {
          desc = "Debug Printf";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>rP";
        action.__raw = ''
          function()
            require('refactoring').debug.print_var()
          end
        '';
        options = {
          desc = "Debug Print Variable";
        };
      }
      {
        mode = "n";
        key = "<leader>rc";
        action.__raw = ''
          function()
            require('refactoring').debug.cleanup({})
          end
        '';
        options = {
          desc = "Debug Cleanup";
        };
      }
    ]
    ++
      lib.optionals
        (
          config.plugins.telescope.enable && config.plugins.refactoring.enable && !config.plugins.lz-n.enable
        )
        [
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
