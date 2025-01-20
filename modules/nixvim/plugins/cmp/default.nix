{ config, lib, ... }:
let
  get_bufnrs.__raw = ''
    function()
      local buf_size_limit = 1024 * 1024 -- 1MB size limit
      local bufs = vim.api.nvim_list_bufs()
      local valid_bufs = {}
      for _, buf in ipairs(bufs) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf)) < buf_size_limit then
          table.insert(valid_bufs, buf)
        end
      end
      return valid_bufs
    end
  '';
in
{
  plugins = {
    cmp = {
      enable = !config.plugins.blink-cmp.enable;
      autoEnableSources = true;

      settings = {
        mapping = {
          "<C-d>" = # Lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = # Lua
            "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = # Lua
            "cmp.mapping.complete()";
          "<C-e>" = # Lua
            "cmp.mapping.close()";
          "<Tab>" = # Lua
            "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<S-Tab>" = # Lua
            "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<CR>" = # Lua
            "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
        };

        preselect = # Lua
          "cmp.PreselectMode.None";

        snippet.expand = # Lua
          "function(args) require('luasnip').lsp_expand(args.body) end";

        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_document_symbol";
            priority = 1000;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "treesitter";
            priority = 850;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "copilot";
            priority = 600;
          }
          # TODO: figure out infinite recursion when making conditional
          # {
          #   name = "codeium";
          #   priority = 600;
          # }
          {
            name = "buffer";
            priority = 500;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "path";
            priority = 300;
          }
          {
            name = "cmdline";
            priority = 300;
          }
          {
            name = "spell";
            priority = 300;
          }
          {
            name = "fish";
            priority = 250;
          }
          {
            name = "git";
            priority = 250;
          }
          # FIXME: lazy load
          # {
          #   name = "neorg";
          #   priority = 250;
          # }
          {
            name = "npm";
            priority = 250;
          }
          {
            name = "tmux";
            priority = 250;
          }
          {
            name = "zsh";
            priority = 250;
          }
          {
            name = "calc";
            priority = 150;
          }
          {
            name = "emoji";
            priority = 100;
          }
          { name = "nixpkgs_maintainers"; }
        ];

        window = {
          completion.__raw = ''cmp.config.window.bordered()'';
          documentation.__raw = ''cmp.config.window.bordered()'';
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.cmp.enable [
    {
      key = "<leader>uc";
      mode = "n";
      action.__raw = ''
        function ()
          vim.g.cmp_enabled = not vim.g.cmp_enabled
          vim.notify(string.format("Completions %s", bool2str(vim.g.cmp_enabled), "info"))
        end'';
      options = {
        desc = "Completions toggle";
      };
    }
  ];
}
