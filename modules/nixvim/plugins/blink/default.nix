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
      # blink use for gitlab ?
      glab
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

        lazyLoad.settings.event = [
          "InsertEnter"
          "CmdlineEnter"
        ];

        settings = {
          cmdline = {
            completion.menu.auto_show = true;
            keymap = {
              preset = "inherit";
            };
          };
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
            # NOTE: If you prefer Tab/S-Tab selection
            # But, find myself accidentally interrupting tabbing for movement
            # "<A-Tab>" = [
            #   "snippet_forward"
            #   "fallback"
            # ];
            # "<A-S-Tab>" = [
            #   "snippet_backward"
            #   "fallback"
            # ];
            # "<Tab>" = [
            #   "select_next"
            #   "fallback"
            # ];
            # "<S-Tab>" = [
            #   "select_prev"
            #   "fallback"
            # ];
          };
          signature = {
            enabled = true;
            window.border = "rounded";
          };
          snippets.preset = "mini_snippets";
          sources = {
            default.__raw = ''
              function(ctx)
                -- Base sources that are always available
                local base_sources = { 'buffer', 'lsp', 'path', 'snippets' }

                -- Build common sources list dynamically based on enabled plugins
                local common_sources = vim.deepcopy(base_sources)

                -- Add optional sources based on plugin availability
                ${lib.optionalString config.plugins.copilot-lua.enable "table.insert(common_sources, 'copilot')"}
                ${lib.optionalString config.plugins.blink-cmp-dictionary.enable "table.insert(common_sources, 'dictionary')"}
                ${lib.optionalString config.plugins.blink-emoji.enable "table.insert(common_sources, 'emoji')"}
                ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-nerdfont-nvim config.extraPlugins) "table.insert(common_sources, 'nerdfont')"}
                ${lib.optionalString config.plugins.blink-cmp-spell.enable "table.insert(common_sources, 'spell')"}
                ${lib.optionalString config.plugins.blink-ripgrep.enable "table.insert(common_sources, 'ripgrep')"}

                -- Special context handling
                local success, node = pcall(vim.treesitter.get_node)
                if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                  return { 'buffer', 'spell', 'dictionary' }
                elseif vim.bo.filetype == 'gitcommit' then
                  local git_sources = { 'buffer', 'spell', 'dictionary' }
                  ${lib.optionalString config.plugins.blink-cmp-git.enable "table.insert(git_sources, 'git')"}
                  ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins) "table.insert(git_sources, 'conventional_commits')"}
                  return git_sources
                ${lib.optionalString config.plugins.avante.enable # Lua
                  ''
                    elseif vim.bo.filetype == 'AvanteInput' then
                      return { 'buffer', 'avante' }
                  ''
                }
                ${lib.optionalString config.plugins.easy-dotnet.enable # Lua
                  ''
                    elseif vim.bo.filetype == "cs" or vim.bo.filetype == "fsharp" or vim.bo.filetype == "vb" or vim.bo.filetype == "razor" or vim.bo.filetype == "xml" then
                      -- For .NET filetypes, add easy-dotnet to the sources
                      local dotnet_sources = vim.deepcopy(common_sources)
                      table.insert(dotnet_sources, 'easy-dotnet')
                      return dotnet_sources
                  ''
                }
                else
                  return common_sources
                end
              end
            '';
            providers = {
              # BUILT-IN SOURCES
              lsp.score_offset = 4;
              # Community sources
              copilot = lib.mkIf config.plugins.copilot-lua.enable {
                name = "copilot";
                module = "blink-copilot";
                async = true;
                score_offset = 100;
              };
              conventional_commits =
                lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins)
                  {
                    name = "Conventional Commits";
                    module = "blink-cmp-conventional-commits";
                    enabled.__raw = ''
                      function()
                        return vim.bo.filetype == 'gitcommit'
                      end
                    '';
                  };
              dictionary = lib.mkIf config.plugins.blink-cmp-dictionary.enable {
                name = "Dict";
                module = "blink-cmp-dictionary";
                min_keyword_length = 3;
              };
              emoji = lib.mkIf config.plugins.blink-emoji.enable {
                name = "Emoji";
                module = "blink-emoji";
                score_offset = 1;
              };
              git = lib.mkIf config.plugins.blink-cmp-git.enable {
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
              ripgrep = lib.mkIf config.plugins.blink-ripgrep.enable {
                name = "Ripgrep";
                module = "blink-ripgrep";
                async = true;
                score_offset = 1;
              };
              spell = lib.mkIf config.plugins.blink-cmp-spell.enable {
                name = "Spell";
                module = "blink-cmp-spell";
                score_offset = 1;
              };
              nerdfont = lib.mkIf (lib.elem pkgs.vimPlugins.blink-nerdfont-nvim config.extraPlugins) {
                module = "blink-nerdfont";
                name = "Nerd Fonts";
                score_offset = 15;
                opts = {
                  insert = true;
                };
              };
              easy-dotnet = lib.mkIf config.plugins.easy-dotnet.enable {
                module = "easy-dotnet.completion.blink";
                name = "easy-dotnet";
                async = true;
                score_offset = 1000;
                enabled.__raw = ''
                  function()
                    return vim.bo.filetype == "xml"
                  end
                '';
              };
              avante = lib.mkIf config.plugins.avante.enable {
                module = "blink-cmp-avante";
                name = "Avante";
                enabled.__raw = ''
                  function()
                    return vim.bo.filetype == 'AvanteInput'
                  end
                '';
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
