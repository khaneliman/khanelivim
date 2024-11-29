{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.blink-cmp.enable [ pkgs.khanelivim.blink-compat ];

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;
        package = pkgs.khanelivim.blink-cmp;
        luaConfig.pre = # lua
          ''
            require('blink.compat').setup({debug = true})
          '';

        settings = {
          accept.auto_brackets.enabled = true;
          nerd_font_variant = "mono";
          kind_icons = {
            Copilot = "";
          };
          highlight = {
            use_nvim_cmp_as_default = true;
          };
          keymap = {
            preset = "enter";
            "<A-Tab>" = [
              "snippet_forward"
              "fallback"
            ];
            "<A-S-Tab>" = [
              "snippet_backward"
              "fallback"
            ];
            "<Tab>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "fallback"
            ];
          };
          sources = {
            completion = {
              enabled_providers = [
                "copilot"
                "lsp"
                "path"
                "snippets"
                "buffer"
                "git"
                "calc"
                "luasnip"
              ];
            };
            providers = {
              lsp = {
                name = "LSP";
                module = "blink.cmp.sources.lsp";
              };
              path = {
                name = "Path";
                module = "blink.cmp.sources.path";
                score_offset = 3;
              };
              snippets = {
                name = "Snippets";
                module = "blink.cmp.sources.snippets";
                score_offset = -3;
              };
              buffer = {
                name = "Buffer";
                module = "blink.cmp.sources.buffer";
                fallback_for = [ "lsp" ];
              };
              git = {
                name = "git";
                module = "blink.compat.source";
              };
              calc = {
                name = "calc";
                module = "blink.compat.source";
              };
              copilot = {
                name = "copilot";
                module = "blink.compat.source";
              };
              luasnip = {
                name = "luasnip";
                module = "blink.compat.source";
                score_offset = -3;
                opts = {
                  use_show_condition = false;
                  show_autosnippets = true;
                };
              };
            };
          };
          trigger = {
            signature_help = {
              enabled = true;
            };
          };
          windows = {
            autocomplete = {
              border = "rounded";
              draw = {
                columns = [
                  {
                    __unkeyed-1 = "label";
                    __unkeyed-2 = "label_description";
                    gap = 1;
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                ];
              };
            };
            documentation = {
              auto_show = true;
              border = "rounded";
            };
            ghost_text = {
              enabled = true;
            };
            signature_help = {
              border = "rounded";
            };
          };
        };
      };
    }
    (lib.mkIf config.plugins.blink-cmp.enable {
      cmp-git.enable = true;
      cmp-calc.enable = true;
      cmp-treesitter.enable = true;
      copilot-cmp.enable = true;

      lsp.capabilities = # Lua
        ''
          capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        '';
    })
  ];
}
