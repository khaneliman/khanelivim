{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins.blink-cmp.settings.sources = {
    default.__raw = /* Lua */ ''
      function(ctx)
        -- Base sources that are always available
        local base_sources = { 'buffer', 'lsp', 'path', 'snippets' }

        -- Build common sources list dynamically based on enabled plugins
        local common_sources = vim.deepcopy(base_sources)

        -- Add optional sources based on plugin availability
        ${lib.optionalString config.plugins.blink-copilot.enable "table.insert(common_sources, 'copilot')"}
        ${lib.optionalString (
          config.plugins.blink-cmp-dictionary.enable || config.plugins.blink-cmp-words.enable
        ) "table.insert(common_sources, 'dictionary')"}
        ${lib.optionalString config.plugins.blink-emoji.enable "table.insert(common_sources, 'emoji')"}
        ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-nerdfont-nvim config.extraPlugins) "table.insert(common_sources, 'nerdfont')"}
        ${lib.optionalString config.plugins.blink-cmp-spell.enable "table.insert(common_sources, 'spell')"}
        ${lib.optionalString config.plugins.blink-cmp-words.enable "table.insert(common_sources, 'thesaurus')"}
        ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-cmp-yanky config.extraPlugins) "table.insert(common_sources, 'yank')"}
        ${lib.optionalString config.plugins.blink-ripgrep.enable "table.insert(common_sources, 'ripgrep')"}
        ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-cmp-npm-nvim config.extraPlugins) "if vim.fn.expand('%:t') == 'package.json' then table.insert(common_sources, 'npm') end"}

        -- Special context handling
        local success, node = pcall(vim.treesitter.get_node)
        if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          local comment_sources = { 'buffer', 'spell' }
          ${lib.optionalString (
            config.plugins.blink-cmp-dictionary.enable || config.plugins.blink-cmp-words.enable
          ) "table.insert(comment_sources, 'dictionary')"}
          ${lib.optionalString config.plugins.blink-cmp-words.enable "table.insert(comment_sources, 'thesaurus')"}
          return comment_sources
        elseif vim.bo.filetype == 'gitcommit' then
          local git_sources = { 'buffer', 'spell' }
          ${lib.optionalString (
            config.plugins.blink-cmp-dictionary.enable || config.plugins.blink-cmp-words.enable
          ) "table.insert(git_sources, 'dictionary')"}
          ${lib.optionalString config.plugins.blink-cmp-words.enable "table.insert(git_sources, 'thesaurus')"}
          ${lib.optionalString config.plugins.blink-cmp-git.enable "table.insert(git_sources, 'git')"}
          ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins) "table.insert(git_sources, 'conventional_commits')"}
          return git_sources
        ${lib.optionalString config.plugins.avante.enable /* Lua */ ''
          elseif vim.bo.filetype == 'AvanteInput' then
            return { 'buffer', 'avante' }
        ''}
        ${lib.optionalString config.plugins.easy-dotnet.enable /* Lua */ ''
          elseif vim.bo.filetype == "cs" or vim.bo.filetype == "fsharp" or vim.bo.filetype == "vb" or vim.bo.filetype == "razor" or vim.bo.filetype == "xml" then
            -- For .NET filetypes, add easy-dotnet to the sources
            local dotnet_sources = vim.deepcopy(common_sources)
            table.insert(dotnet_sources, 'easy-dotnet')
            return dotnet_sources
        ''}
        else
          return common_sources
        end
      end
    '';

    providers = {
      # BUILT-IN SOURCES
      # keep-sorted start block=yes newline_separated=yes
      buffer = {
        score_offset = 45;
        min_keyword_length = 2;
        max_items = 15;
        opts = {
          # Allow searching all open buffers or just current.
          get_bufnrs.__raw = ''
            function()
              if vim.g.blink_buffer_all_buffers == nil then vim.g.blink_buffer_all_buffers = true end

              if vim.g.blink_buffer_all_buffers then
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              else
                return { vim.api.nvim_get_current_buf() }
              end
            end
          '';
        };
      };

      lsp = {
        score_offset = 80;
        fallbacks = [ ]; # Allow buffer to show independently
        transform_items.__raw = ''
          function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
            end, items)
          end
        '';
      };

      path = {
        score_offset = 55;
        opts = {
          # Toggle support for path completions from project root. Default normal behavior
          get_cwd.__raw = ''
            function(context)
              if vim.g.blink_path_from_cwd == nil then vim.g.blink_path_from_cwd = false end

              if vim.g.blink_path_from_cwd then
                return vim.fn.getcwd()
              else
                local bufpath = vim.api.nvim_buf_get_name(context.bufnr)
                if bufpath == "" then
                  return vim.fn.getcwd()
                end
                return vim.fn.fnamemodify(bufpath, ":p:h")
              end
            end
          '';
        };
      };

      snippets = {
        score_offset = 60;
        should_show_items.__raw = ''
          function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end
        '';
      };
      # keep-sorted end

      # Community sources
      # keep-sorted start block=yes newline_separated=yes
      avante = lib.mkIf config.plugins.avante.enable {
        module = "blink-cmp-avante";
        name = "Avante";
        score_offset = 68;
        enabled.__raw = ''
          function()
            return vim.bo.filetype == 'AvanteInput'
          end
        '';
      };

      conventional_commits =
        lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins)
          {
            name = "Conventional Commits";
            module = "blink-cmp-conventional-commits";
            score_offset = 68;
            enabled.__raw = ''
              function()
                return vim.bo.filetype == 'gitcommit'
              end
            '';
          };

      copilot = lib.mkIf config.plugins.blink-copilot.enable {
        name = "copilot";
        module = "blink-copilot";
        async = true;
        timeout_ms = 1000;
        max_items = 3;
        score_offset = 1000;
      };

      dictionary =
        lib.mkIf (config.plugins.blink-cmp-dictionary.enable || config.plugins.blink-cmp-words.enable)
          {
            name = "Dict";
            module =
              if config.plugins.blink-cmp-words.enable then
                "blink-cmp-words.dictionary"
              else
                "blink-cmp-dictionary";
            min_keyword_length = 3;
            max_items = 8;
            score_offset = 8;
            opts = lib.mkIf config.plugins.blink-cmp-words.enable {
              dictionary_search_threshold = 3;
              definition_pointers = [
                "!"
                "&"
                "^"
              ];
            };
          };

      easy-dotnet = lib.mkIf config.plugins.easy-dotnet.enable {
        module = "easy-dotnet.completion.blink";
        name = "easy-dotnet";
        async = true;
        score_offset = 80;
        enabled.__raw = ''
          function()
            return vim.bo.filetype == "xml"
          end
        '';
      };

      emoji = lib.mkIf config.plugins.blink-emoji.enable {
        name = "Emoji";
        module = "blink-emoji";
        score_offset = 10;
      };

      git = lib.mkIf config.plugins.blink-cmp-git.enable {
        name = "Git";
        module = "blink-cmp-git";
        enabled = true;
        score_offset = 70;
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

      nerdfont = lib.mkIf (lib.elem pkgs.vimPlugins.blink-nerdfont-nvim config.extraPlugins) {
        module = "blink-nerdfont";
        name = "Nerd Fonts";
        score_offset = 68;
        opts = {
          insert = true;
        };
      };

      npm = lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-npm-nvim config.extraPlugins) {
        name = "npm";
        module = "blink-cmp-npm";
        async = true;
        timeout_ms = 2000;
        score_offset = 70;
        enabled.__raw = ''
          function()
            return vim.fn.expand('%:t') == 'package.json'
          end
        '';
        opts = {
          ignore = { };
          only_semantic_versions = true;
          only_latest_version = false;
        };
      };

      ripgrep = lib.mkIf config.plugins.blink-ripgrep.enable {
        name = "Ripgrep";
        module = "blink-ripgrep";
        async = true;
        timeout_ms = 500;
        max_items = 10;
        min_keyword_length = 4;
        score_offset = 5;
      };

      spell = lib.mkIf config.plugins.blink-cmp-spell.enable {
        name = "Spell";
        module = "blink-cmp-spell";
        max_items = 3;
        score_offset = 15;
      };

      thesaurus = lib.mkIf config.plugins.blink-cmp-words.enable {
        name = "Thesaurus";
        module = "blink-cmp-words.thesaurus";
        min_keyword_length = 3;
        max_items = 8;
        score_offset = 10;
        opts = {
          definition_pointers = [
            "!"
            "&"
            "^"
          ];
          similarity_pointers = [
            "&"
            "^"
          ];
          similarity_depth = 2;
        };
      };

      yank = lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-yanky config.extraPlugins) {
        name = "yank";
        module = "blink-yanky";
        score_offset = 69;
        max_items = 3;
      };
      # keep-sorted end
    };
  };
}
