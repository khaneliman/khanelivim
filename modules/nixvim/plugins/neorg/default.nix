{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.neorg.enable [
    pkgs.vimPlugins.neorg-interim-ls
  ];

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

  plugins = {
    neorg = {
      enable = true;

      lazyLoad.settings = {
        ft = "norg";
        cmd = "Neorg";
      };

      settings = {
        # lazy_loading = true;  # Disabled - requires NeorgStart command

        load = {
          "core.defaults" = lib.mkIf config.plugins.treesitter.enable { __empty = null; };

          "core.keybinds".config.hook.__raw = ''
            function(keybinds)
              -- Unmap conflicting default keybinds
              keybinds.unmap('norg', 'n', '<C-s>')
            end
          '';

          "core.dirman".config.workspaces = {
            notes = "~/notes";
            nix = "~/perso/nix/notes";
          };

          "core.concealer".__empty = null;

          # Completion via LSP using neorg-interim-ls for blink.cmp support
          # See: https://github.com/nvim-neorg/neorg/issues/1603
          "core.completion".config.engine = {
            module_name = "external.lsp-completion";
          };

          "external.interim-ls".config = {
            completion_provider = {
              enable = true;
              documentation = true;
            };
          };

          # Enable journal module
          "core.journal".config = {
            workspace = "notes";
            journal_folder = "journal";
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.neorg.enable [
      {
        __unkeyed-1 = "<leader>n";
        group = "Notes";
        icon = " ";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.neorg.enable (
    [
      # Workspace operations
      {
        mode = "n";
        key = "<leader>ni";
        action = "<cmd>Neorg index<CR>";
        options.desc = "Open Index";
      }
      {
        mode = "n";
        key = "<leader>nw";
        action = "<cmd>Neorg workspace<CR>";
        options.desc = "Select Workspace";
      }
      {
        mode = "n";
        key = "<leader>nr";
        action = "<cmd>Neorg return<CR>";
        options.desc = "Return to Workspace";
      }

      # Journal operations
      {
        mode = "n";
        key = "<leader>nj";
        action = "<cmd>Neorg journal today<CR>";
        options.desc = "Today's Journal";
      }
      {
        mode = "n";
        key = "<leader>ny";
        action = "<cmd>Neorg journal yesterday<CR>";
        options.desc = "Yesterday's Journal";
      }
      {
        mode = "n";
        key = "<leader>nt";
        action = "<cmd>Neorg journal tomorrow<CR>";
        options.desc = "Tomorrow's Journal";
      }
      {
        mode = "n";
        key = "<leader>nJ";
        action.__raw = ''
          function()
            vim.ui.input({ prompt = "Journal date (YYYY-MM-DD): " }, function(date)
              if date and date ~= "" then
                vim.cmd("Neorg journal custom " .. date)
              end
            end)
          end
        '';
        options.desc = "Custom Date Journal";
      }

      # UI toggles
      {
        mode = "n";
        key = "<leader>nc";
        action = "<cmd>Neorg toggle-concealer<CR>";
        options.desc = "Toggle Concealer";
      }

      # Note creation
      {
        mode = "n";
        key = "<leader>nn";
        action.__raw = ''
          function()
            vim.ui.input({ prompt = "Note name: " }, function(name)
              if name and name ~= "" then
                vim.cmd("edit ~/notes/" .. name .. ".norg")
              end
            end)
          end
        '';
        options.desc = "New Note";
      }
    ]
    ++ lib.optionals (config.khanelivim.picker.tool == "snacks") [
      {
        mode = "n";
        key = "<leader>ns";
        action = "<cmd>lua Snacks.picker.files({ cwd = '~/notes' })<CR>";
        options.desc = "Search Notes";
      }
      {
        mode = "n";
        key = "<leader>ng";
        action = "<cmd>lua Snacks.picker.grep({ cwd = '~/notes' })<CR>";
        options.desc = "Grep Notes";
      }
    ]
  );
}
