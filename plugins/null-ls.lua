local utils = require "astronvim.utils"
return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local nls = require "null-ls"
    if type(opts.sources) == "table" then
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.statix,
        -- nls.builtins.formatting.alejandra,
        nls.builtins.diagnostics.deadnix,
      })
    end
  end,
}
