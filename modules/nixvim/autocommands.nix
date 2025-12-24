{ config, lib, ... }:
{
  autoCmd = [
    # Remove trailing whitespace on save
    (lib.mkIf (!lib.elem "trim_whitespace" config.plugins.conform-nvim.settings.formatters_by_ft."_") {
      event = "BufWrite";
      command = "%s/\\s\\+$//e";
    })

    # Handle performance on large files
    (lib.mkIf
      (
        (!config.plugins.faster.enable)
        && (
          (!config.plugins.snacks.enable)
          || (config.plugins.snacks.enable && (!config.plugins.snacks.settings.bigfile.enabled))
        )
      )
      {
        event = "BufEnter";
        pattern = [ "*" ];
        callback.__raw = ''
          function()
            local buf_size_limit = 1024 * 1024 -- 1MB size limit
            if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
              ${lib.optionalString config.plugins.mini-indentscope.enable ''vim.b.miniindentscope_disable = true''}
              ${lib.optionalString config.plugins.blink-indent.enable ''vim.b.indent_guide = false''}
              ${lib.optionalString (
                config.plugins.snacks.enable && config.plugins.snacks.settings.indent.enabled
              ) ''vim.b.snacks_indent = false''}
              ${lib.optionalString config.plugins.illuminate.enable ''require("illuminate").pause_buf()''}

              -- Disable line numbers and relative line numbers
              vim.cmd("setlocal nonumber norelativenumber")

              -- Disable syntax highlighting
              -- vim.cmd("syntax off")

              -- Disable matchparen
              vim.cmd("let g:loaded_matchparen = 1")

              -- Disable cursor line and column
              vim.cmd("setlocal nocursorline nocursorcolumn")

              -- Disable folding
              vim.cmd("setlocal nofoldenable")

              -- Disable sign column
              vim.cmd("setlocal signcolumn=no")

              -- Disable swap file and undo file
              vim.cmd("setlocal noswapfile noundofile")

              -- Disable mini animate
              vim.b.minianimate_disable = true
            end
          end
        '';
      }
    )

    # Open minimap on first buffer
    # {
    #   event = "BufRead";
    #   once = true;
    #   callback = {
    #     __raw =
    #       "MiniMap.open";
    #   };
    # }

    # Open Neo-Tree on first buffer
    # {
    #   event = "BufWinEnter";
    #   callback = {
    #     __raw =
    #       ''
    #         function(table)
    #           if vim.api.nvim_buf_get_name(0) ~= "" and not vim.g.first_buffer_opened then
    #             vim.g.first_buffer_opened = true
    #             vim.api.nvim_exec2('Neotree show filesystem left', { output = false })
    #           end
    #         end
    #       '';
    #   };
    # }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
      ];
      command = "setlocal spell spelllang=en_us";
    }

    # Auto-reload files changed externally
    {
      event = [
        "FocusGained"
        "BufEnter"
        "CursorHold"
        "CursorHoldI"
      ];
      pattern = "*";
      command = "if mode() != 'c' | checktime | endif";
    }
  ];
}
