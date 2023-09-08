-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        lua_ls = { settings = { Lua = { hint = { enable = true, arrayIndex = "Disable" } } } },
      },
      features = {
        inlay_hints = true,
      },
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      handlers = {
        rust_analyzer = false,
        tsserver = false,
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    init = function()
      local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Load clangd_extensions with clangd",
        callback = function(args)
          if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
            require "clangd_extensions"
            vim.api.nvim_del_augroup_by_id(augroup)
          end
        end,
      })
    end,
  },
}
