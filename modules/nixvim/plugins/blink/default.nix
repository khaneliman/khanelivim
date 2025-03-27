{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = lib.mkIf config.plugins.blink-cmp.enable (
    with pkgs;
    [
      # blink-cmp-git
      gh
      # blink-cmp-dictionary
      wordnet
    ]
  );

  extraPlugins = with pkgs.vimPlugins; [
    blink-cmp-avante
    blink-cmp-conventional-commits
    blink-nerdfont-nvim
  ];

  plugins = lib.mkMerge [
    {
      blink-cmp = {
        enable = true;

        # TODO: fix fuzzy library check with lazy loading
        # plugin searches `start` instead of `opt` in pack
        # lazyLoad.settings.event = [
        #   "InsertEnter"
        #   "CmdlineEnter"
        # ];

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
            implementation = "rust";
            prebuilt_binaries = {
              download = false;
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
                "conventional_commits"
                "dictionary"
                "emoji"
                "git"
                "nerdfont"
                "spell"
                # FIXME: locking up nvim
                # "ripgrep"
              ]
              ++ lib.optionals config.plugins.avante.enable [
                "avante"
              ]
              ++ lib.optionals config.plugins.easy-dotnet.enable [
                "easy-dotnet"
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
                conventional_commits = {
                  name = "Conventional Commits";
                  module = "blink-cmp-conventional-commits";
                  enabled.__raw = ''
                    function()
                      return vim.bo.filetype == 'gitcommit'
                    end
                  '';
                };
                dictionary = {
                  name = "Dict";
                  module = "blink-cmp-dictionary";
                  min_keyword_length = 3;
                };
                emoji = {
                  name = "Emoji";
                  module = "blink-emoji";
                  score_offset = 1;
                };
                git = {
                  name = "Git";
                  module = "blink-cmp-git";
                  enabled = true;
                  score_offset = 100;
                  should_show_items.__raw = ''
                    function()
                      return vim.o.filetype == 'gitcommit' or vim.o.filetype == 'markdown'
                    end
                  '';
                  opts = {
                    git_centers = {
                      github = {
                        issue = {
                          on_error.__raw = "function(_,_) return true end";
                        };
                      };
                    };
                  };
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
                nerdfont = {
                  module = "blink-nerdfont";
                  name = "Nerd Fonts";
                  score_offset = 15;
                  opts = {
                    insert = true;
                  };
                };
              }
              // lib.optionalAttrs config.plugins.avante.enable {
                easy-dotnet = {
                  module = "easy-dotnet.completion.blink";
                  name = "easy-dotnet";
                  async = true;
                  score_offset = 1000;
                };
              }
              // lib.optionalAttrs config.plugins.avante.enable {
                avante = {
                  module = "blink-cmp-avante";
                  name = "Avante";
                };
              };
          };
        };
      };

      blink-cmp-copilot.enable = !config.plugins.blink-copilot.enable;
      blink-cmp-dictionary.enable = true;
      blink-cmp-git.enable = true;
      blink-cmp-spell.enable = true;
      blink-copilot.enable = true;
      blink-emoji.enable = true;
      blink-ripgrep.enable = true;
    }
  ];
}
