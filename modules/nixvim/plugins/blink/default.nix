{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.blink-cmp.enable (
    with pkgs.vimPlugins;
    [
      blink-cmp-spell
      blink-copilot
      blink-emoji-nvim
      blink-ripgrep-nvim
    ]
  );

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;
        package = inputs.blink-cmp.packages.${system}.default;

        settings = {
          completion = {
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              window.border = "rounded";
            };
            list.selection = {
              auto_insert = false;
              preselect = false;
            };
            menu = {
              border = "rounded";
              draw = {
                columns = [
                  {
                    __unkeyed-1 = "label";
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                  { __unkeyed-1 = "source_name"; }
                ];
                components = {
                  kind_icon = {
                    ellipsis = false;
                    text.__raw = ''
                      function(ctx)
                        local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                        -- Check for both nil and the default fallback icon
                        if not kind_icon or kind_icon == '󰞋' then
                          -- Use our configured kind_icons
                          return require('blink.cmp.config').appearance.kind_icons[ctx.kind] or ""
                        end
                        return kind_icon
                      end,
                      -- Optionally, you may also use the highlights from mini.icons
                      highlight = function(ctx)
                        local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                        return hl
                      end
                    '';
                  };
                };
              };
            };
          };
          fuzzy = {
            prebuilt_binaries = {
              download = false;
              ignore_version_mismatch = true;
            };
          };
          appearance = {
            use_nvim_cmp_as_default = true;
            kind_icons = {
              Copilot = "";
            };
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
          signature = {
            enabled = true;
            window.border = "rounded";
          };
          snippets.preset = "mini_snippets";
          sources = {
            default =
              [
                # BUILT-IN SOURCES
                "buffer"
                "lsp"
                "path"
                "snippets"
                # Community
                "copilot"
                "emoji"
                "spell"
                # FIXME: locking up nvim
                # "ripgrep"
                # Cmp sources
                # TODO: migrate when available
                "calc"
                "git"
                "zsh"
              ]
              ++ lib.optionals config.plugins.avante.enable [
                "avante_commands"
                "avante_files"
                "avante_mentions"
              ];
            providers =
              {
                # BUILT-IN SOURCES
                lsp.score_offset = 4;
                # Community sources
                copilot = {
                  name = "copilot";
                  module = "blink-copilot";
                  async = true;
                  score_offset = 100;
                };
                emoji = {
                  name = "Emoji";
                  module = "blink-emoji";
                  score_offset = 1;
                };
                ripgrep = {
                  name = "Ripgrep";
                  module = "blink-ripgrep";
                  async = true;
                  score_offset = 1;
                };
                spell = {
                  name = "Spell";
                  module = "blink-cmp-spell";
                  score_offset = 1;
                };
              }
              // lib.optionalAttrs config.plugins.blink-compat.enable {
                # Cmp sources
                calc = {
                  name = "calc";
                  module = "blink.compat.source";
                  score_offset = 2;
                };
                git = {
                  name = "git";
                  module = "blink.compat.source";
                  score_offset = 0;
                };
                npm = {
                  name = "npm";
                  module = "blink.compat.source";
                  score_offset = -3;
                };
                zsh = {
                  name = "zsh";
                  module = "blink.compat.source";
                  score_offset = -3;
                };
              }
              // lib.optionalAttrs (config.plugins.avante.enable && config.plugins.blink-compat.enable) {
                avante_commands = {
                  name = "avante_commands";
                  module = "blink.compat.source";
                  score_offset = 90;
                };
                avante_files = {
                  name = "avante_files";
                  module = "blink.compat.source";
                  score_offset = 100;
                };
                avante_mentions = {
                  name = "avante_mentions";
                  module = "blink.compat.source";
                  score_offset = 1000;
                };
              };
          };
        };
      };

      # TODO: replace with blink-copilot module
      # blink-cmp-copilot = {
      #   enable = true;
      # };

      blink-compat = {
        enable = true;

        settings = {
          # When wanted
          # debug = true;
          # NOTE: apparently just doesn't work without using lazy...
          # impersonate_nvim_cmp = true;
        };
      };
    }
    (lib.mkIf config.plugins.blink-cmp.enable {
      cmp-calc.enable = true;
      cmp-git.enable = true;
      cmp-zsh.enable = true;

      lsp.capabilities = # Lua
        ''
          capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
        '';
    })
  ];
}
