{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        toggle.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "toggle" config.plugins.snacks.settings
        && config.plugins.snacks.settings.toggle.enabled
      )
      (
        [
          # Diagnostics toggles (replaces manual)
          {
            mode = "n";
            key = "<leader>ud";
            action.__raw = "function() Snacks.toggle.diagnostics():toggle() end";
            options.desc = "Buffer Diagnostics toggle";
          }
          {
            mode = "n";
            key = "<leader>uD";
            action.__raw = "function() Snacks.toggle.diagnostics():toggle() end";
            options.desc = "Global Diagnostics toggle";
          }

          # Spell toggle (replaces manual)
          {
            mode = "n";
            key = "<leader>uS";
            action.__raw = "function() Snacks.toggle.option('spell', { name = 'Spelling' }):toggle() end";
            options.desc = "Spell toggle";
          }

          # Wrap toggle (replaces manual)
          {
            mode = "n";
            key = "<leader>uw";
            action.__raw = "function() Snacks.toggle.option('wrap', { name = 'Wrap' }):toggle() end";
            options.desc = "Word Wrap toggle";
          }

          # Snacks-specific toggles (zen/dim are in their own modules)
        ]
        ++ lib.optionals (!config.plugins.mini-animate.enable) [
          {
            mode = "n";
            key = "<leader>ua";
            action.__raw = "function() Snacks.toggle.animate():toggle() end";
            options.desc = "Toggle Animations";
          }
        ]
        ++ lib.optionals (config.khanelivim.ui.indentGuides == "snacks") [
          {
            mode = "n";
            key = "<leader>ui";
            action.__raw = "function() Snacks.toggle.indent():toggle() end";
            options.desc = "Toggle Indent Guides";
          }
        ]
        ++ [
          {
            mode = "n";
            key = "<leader>uh";
            action.__raw = "function() Snacks.toggle.inlay_hints():toggle() end";
            options.desc = "Toggle Inlay Hints";
          }
          {
            mode = "n";
            key = "<leader>ul";
            action.__raw = "function() Snacks.toggle.line_number():toggle() end";
            options.desc = "Toggle Line Numbers";
          }
          {
            mode = "n";
            key = "<leader>up";
            action.__raw = "function() Snacks.toggle.profiler():toggle() end";
            options.desc = "Toggle Profiler";
          }
          {
            mode = "n";
            key = "<leader>uP";
            action.__raw = "function() Snacks.toggle.profiler_highlights():toggle() end";
            options.desc = "Toggle Profiler Highlights";
          }
          {
            mode = "n";
            key = "<leader>us";
            action.__raw = "function() Snacks.toggle.scroll():toggle() end";
            options.desc = "Toggle Smooth Scroll";
          }
          {
            mode = "n";
            key = "<leader>uT";
            action.__raw = "function() Snacks.toggle.treesitter():toggle() end";
            options.desc = "Toggle Treesitter Highlight";
          }
          {
            mode = "n";
            key = "<leader>ur";
            action.__raw = "function() Snacks.toggle.words():toggle() end";
            options.desc = "Toggle Reference Highlighting";
          }
          {
            mode = "n";
            key = "<leader>ufc";
            action.__raw = ''
              function()
                local curr_foldcolumn = vim.wo.foldcolumn
                if curr_foldcolumn ~= "0" then vim.g.last_active_foldcolumn = curr_foldcolumn end
                vim.wo.foldcolumn = curr_foldcolumn == "0" and (vim.g.last_active_foldcolumn or "1") or "0"
                vim.notify(string.format("Fold Column %s", bool2str(vim.wo.foldcolumn), "info"))
              end
            '';
            options.desc = "Toggle Fold Column";
          }
          {
            mode = "n";
            key = "<leader>utb";
            action = "<cmd>TabsToggle<CR>";
            options.desc = "Toggle Tabs/Spaces";
          }
          {
            mode = "n";
            key = "<leader>uW";
            action.__raw = ''
              function()
                if (not vim.g.whitespace_character_enabled) then
                  vim.cmd('set listchars=eol:¬,tab:>→,trail:~,extends:>,precedes:<,space:·')
                  vim.cmd('set list')
                else
                  vim.cmd('set nolist')
                end
                vim.g.whitespace_character_enabled = not vim.g.whitespace_character_enabled
                vim.notify(string.format("Showing white space characters %s", bool2str(vim.g.whitespace_character_enabled), "info"))
              end
            '';
            options.desc = "Toggle Whitespace Characters";
          }
          {
            mode = "n";
            key = "<leader>uz";
            action.__raw = "function() Snacks.toggle.dim():toggle() end";
            options.desc = "Toggle Dim";
          }
          {
            mode = "n";
            key = "<leader>uZ";
            action.__raw = "function() Snacks.toggle.zen():toggle() end";
            options.desc = "Toggle Zen Mode";
          }
          {
            mode = "n";
            key = "<leader>um";
            action.__raw = "function() Snacks.toggle.zoom():toggle() end";
            options.desc = "Toggle Zoom (Maximize)";
          }
        ]
      );
}
