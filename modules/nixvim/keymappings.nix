{
  config,
  lib,
  ...
}:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps =
    let
      normal =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "n";
              inherit action key;
              options = attrs.options or { };
            }
          )
          (
            {
              "<Space>" = {
                action = "<NOP>";
              };

              # Esc to clear search results
              "<esc>" = {
                action = "<cmd>noh<CR>";
              };

              # Backspace delete in normal
              "<BS>" = {
                action = "<BS>x";
              };

              # fix Y behaviour
              "Y" = {
                action = "y$";
              };

              # back and fourth between the two most recent files
              "<C-c>" = {
                action = "<cmd>b#<CR>";
              };

              # navigate to left/right window
              "<leader>[" = {
                action = "<C-w>h";
                options = {
                  desc = "Left window";
                };
              };
              "<leader>]" = {
                action = "<C-w>l";
                options = {
                  desc = "Right window";
                };
              };
              "<leader>." = {
                action = "<C-w>j";
                options = {
                  desc = "Up window";
                };
              };
              "<leader>," = {
                action = "<C-w>k";
                options = {
                  desc = "Down window";
                };
              };

              # navigate quickfix list
              "<C-[>" = {
                action = "<cmd>cnext<CR>";
              };
              "<C-]>" = {
                action = "<cmd>cprev<CR>";
              };

              # resize with arrows
              "<C-Up>" = {
                action = "<cmd>resize -2<CR>";
              };
              "<C-Down>" = {
                action = "<cmd>resize +2<CR>";
              };
              "<C-Left>" = {
                action = "<cmd>vertical resize +2<CR>";
              };
              "<C-Right>" = {
                action = "<cmd>vertical resize -2<CR>";
              };

              # move current line up/down
              # M = Alt key
              "<M-k>" = {
                action = "<cmd>move-2<CR>";
              };
              "<M-j>" = {
                action = "<cmd>move+<CR>";
              };

              "<Leader>w" = {
                action = "<Cmd>w<CR>"; # Action to perform (save the file in this case)
                options = {
                  desc = "Save";
                };
              };

              "j" = {
                action = "v:count == 0 ? 'gj' : 'j'";
                options = {
                  desc = "Move cursor down";
                  expr = true;
                };
              };
              "k" = {
                action = "v:count == 0 ? 'gk' : 'k'";
                options = {
                  desc = "Move cursor up";
                  expr = true;
                };
              };
              "<Leader>q" = {
                action = "<Cmd>confirm q<CR>";
                options = {
                  desc = "Quit";
                };
              };
              "<C-n>" = {
                action = "<Cmd>enew<CR>";
                options = {
                  desc = "New file";
                };
              };
              "<leader>W" = {
                action = "<Cmd>w!<CR>";
                options = {
                  desc = "Force write";
                };
              };
              "<leader>Q" = {
                action = "<Cmd>q!<CR>";
                options = {
                  desc = "Force quit";
                };
              };
              "|" = {
                action = "<Cmd>vsplit<CR>";
                options = {
                  desc = "Vertical split";
                };
              };
              "-" = {
                action = "<Cmd>split<CR>";
                options = {
                  desc = "Horizontal split";
                };
              };

              "<leader>b]" = {
                action = "<cmd>bnext<CR>";
                options = {
                  desc = "Next buffer";
                };
              };
              "<TAB>" = {
                action = "<cmd>bnext<CR>";
                options = {
                  desc = "Next buffer (default)";
                };
              };
              "<leader>b[" = {
                action = "<cmd>bprevious<CR>";
                options = {
                  desc = "Previous buffer";
                };
              };
              "<S-TAB>" = {
                action = "<cmd>bprevious<CR>";
                options = {
                  desc = "Previous buffer";
                };
              };

            }
            // (lib.optionalAttrs
              (
                !(
                  config.plugins.snacks.enable
                  && lib.hasAttr "toggle" config.plugins.snacks.settings
                  && config.plugins.snacks.settings.toggle.enabled
                )
              )
              {
                "<leader>ud" = {
                  action.__raw = ''
                    function ()
                      vim.b.disable_diagnostics = not vim.b.disable_diagnostics
                      vim.diagnostic.enable(not vim.b.disable_diagnostics, { bufnr = 0 })
                      vim.notify(string.format("Buffer Diagnostics %s", bool2str(not vim.b.disable_diagnostics), "info"))
                    end'';
                  options = {
                    desc = "Buffer Diagnostics toggle";
                  };
                };

                "<leader>uD" = {
                  action.__raw = ''
                    function ()
                      vim.g.disable_diagnostics = not vim.g.disable_diagnostics
                      vim.diagnostic.enable(not vim.g.disable_diagnostics)
                      vim.notify(string.format("Global Diagnostics %s", bool2str(not vim.g.disable_diagnostics), "info"))
                    end'';
                  options = {
                    desc = "Global Diagnostics toggle";
                  };
                };

                "<leader>uS" = {
                  action.__raw = ''
                    function ()
                      if vim.g.spell_enabled then vim.cmd('setlocal nospell') end
                      if not vim.g.spell_enabled then vim.cmd('setlocal spell') end
                      vim.g.spell_enabled = not vim.g.spell_enabled
                      vim.notify(string.format("Spell %s", bool2str(vim.g.spell_enabled), "info"))
                    end'';
                  options = {
                    desc = "Spell toggle";
                  };
                };

                "<leader>uw" = {
                  action.__raw = ''
                    function ()
                      vim.wo.wrap = not vim.wo.wrap
                      vim.notify(string.format("Wrap %s", bool2str(vim.wo.wrap), "info"))
                    end'';
                  options = {
                    desc = "Word Wrap toggle";
                  };
                };
                "<leader>uh" = {
                  action.__raw = ''
                    function ()
                      local curr_foldcolumn = vim.wo.foldcolumn
                      if curr_foldcolumn ~= "0" then vim.g.last_active_foldcolumn = curr_foldcolumn end
                      vim.wo.foldcolumn = curr_foldcolumn == "0" and (vim.g.last_active_foldcolumn or "1") or "0"
                      vim.notify(string.format("Fold Column %s", bool2str(vim.wo.foldcolumn), "info"))
                    end'';
                  options = {
                    desc = "Fold Column toggle";
                  };
                };

                "<leader>uT" = {
                  action = "<cmd>TabsToggle<CR>";
                  options = {
                    desc = "Toggle tabs/spaces";
                  };
                };
              }
            )
            // {
              # Autoformat toggles (no snacks equivalent, always available)
              "<leader>uf" = {
                action.__raw = ''
                  function ()
                    vim.cmd('FormatToggle!')
                    vim.notify(string.format("Buffer Autoformatting %s", bool2str(not vim.b[0].disable_autoformat), "info"))
                  end'';
                options = {
                  desc = "Buffer Autoformatting toggle";
                };
              };

              "<leader>uF" = {
                action.__raw = ''
                  function ()
                    vim.cmd('FormatToggle')
                    vim.notify(string.format("Global Autoformatting %s", bool2str(not vim.g.disable_autoformat), "info"))
                  end'';
                options = {
                  desc = "Global Autoformatting toggle";
                };
              };

              # Base diff keybinds - always available
              "<leader>gdd" = {
                action = "<cmd>diffthis<CR>";
                options = {
                  desc = "Add file to diff";
                };
              };
              "<leader>gdc" = {
                action = "<cmd>diffoff<CR>";
                options = {
                  desc = "Close diff mode";
                };
              };
              "<leader>gdC" = {
                action = "<cmd>diffoff!<CR>";
                options = {
                  desc = "Close diff mode (all windows)";
                };
              };
            }
            // (lib.optionalAttrs (config.khanelivim.git.diffViewer == "none") {
              "<leader>gD" = {
                action.__raw = ''
                  function()
                    if vim.wo.diff then
                      vim.cmd('diffoff')
                    else
                      vim.cmd('diffthis')
                    end
                  end
                '';
                options = {
                  desc = "Toggle Diff (Primary)";
                };
              };
            })
            // {
              "<leader>uW" = {
                action.__raw = ''
                  function ()
                    if (not vim.g.whitespace_character_enabled) then
                      vim.cmd('set listchars=eol:¬,tab:>→,trail:~,extends:>,precedes:<,space:·')
                      vim.cmd('set list')
                    else
                      vim.cmd('set nolist')
                    end
                    vim.g.whitespace_character_enabled = not vim.g.whitespace_character_enabled
                    vim.notify(string.format("Showing white space characters %s", bool2str(vim.g.whitespace_character_enabled), "info"))
                  end'';
                options = {
                  desc = "White space character toggle";
                };
              };
            }
            // (lib.optionalAttrs
              (
                !config.plugins.snacks.enable
                || (config.plugins.snacks.enable && config.plugins.snacks.settings.bufdelete.enabled)
              )
              {
                "<leader>bC" = {
                  action = "<cmd>%bd!<CR>";
                  options = {
                    desc = "Close all buffers";
                  };
                };
              }
            )
          );
      visual =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "v";
              inherit action key;
              options = attrs.options or { };
            }
          )
          {
            # Better indenting
            "<S-Tab>" = {
              action = "<gv";
              options = {
                desc = "Unindent line";
              };
            };
            "<" = {
              action = "<gv";
              options = {
                desc = "Unindent line";
              };
            };
            "<Tab>" = {
              action = ">gv";
              options = {
                desc = "Indent line";
              };
            };
            ">" = {
              action = ">gv";
              options = {
                desc = "Indent line";
              };
            };

            # Move selected line/block in visual mode
            "K" = {
              action = "<cmd>m '<-2<CR>gv=gv<cr>";
            };
            "J" = {
              action = "<cmd>m '>+1<CR>gv=gv<cr>";
            };

            # Backspace delete in visual
            "<BS>" = {
              action = "x";
            };
          };
      insert =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "i";
              inherit action key;
              options = attrs.options or { };
            }
          )
          {
            # Move selected line/block in insert mode
            "<C-k>" = {
              action = "<C-o>gk";
            };
            "<C-h>" = {
              action = "<Left>";
            };
            "<C-l>" = {
              action = "<Right>";
            };
            "<C-j>" = {
              action = "<C-o>gj";
            };
          };
    in
    lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual ++ insert);
}
