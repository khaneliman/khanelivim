{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        bigfile = {
          enabled = lib.elem config.khanelivim.performance.optimizer [
            "snacks"
            "both"
          ];

          size = 1024 * 1024; # 1MB
          setup.__raw = ''
            function(ctx)
              if vim.fn.exists(":NoMatchParen") ~= 0 then
                vim.cmd([[NoMatchParen]])
              end

              ${lib.optionalString config.plugins.indent-blankline.enable ''require("ibl").setup_buffer(0, { enabled = false })''}
              ${lib.optionalString (lib.hasAttr "indentscope" config.plugins.mini.modules) ''vim.b.miniindentscope_disable = true''}
              ${lib.optionalString config.plugins.illuminate.enable ''require("illuminate").pause_buf()''}

              -- Disable line numbers and relative line numbers
              vim.cmd("setlocal nonumber norelativenumber")

              -- Syntax highlighting
              vim.schedule(function()
                vim.bo[ctx.buf].syntax = ctx.ft
              end)

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
              vim.b.minihipatterns_disable = true

              Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })

              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(ctx.buf) then
                  vim.bo[ctx.buf].syntax = ctx.ft
                end
              end)
            end
          '';
        };
      };
    };
  };
}
