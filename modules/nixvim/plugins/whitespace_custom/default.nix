{
  lib,
  config,
  ...
}:
{
  extraConfigLua = lib.mkIf (config.khanelivim.text.whitespace == "whitespace-custom") /* Lua */ ''
    local ignored_filetypes = {
      "Avante",
      "AvanteInput",
      "TelescopePrompt",
      "Trouble",
      "blink-cmp-documentation",
      "blink-cmp-menu",
      "blink-cmp-signature",
      "checkhealth",
      "copilot-chat",
      "dashboard",
      "fzf",
      "help",
      "ministarter",
      "snacks_dashboard",
    }

    local function should_highlight()
      local filetype = vim.bo.filetype
      local buftype = vim.bo.buftype

      -- Check filetype first
      if vim.tbl_contains(ignored_filetypes, filetype) then
        return false
      end

      -- Ignore terminal buffers
      if buftype == "terminal" then
        return false
      end

      -- Ignore nofile buffers (unless caught by filetype above)
      if buftype == "nofile" then
        return false
      end

      return true
    end

    local function highlight_whitespace()
      if should_highlight() then
        vim.cmd([[match DiffDelete /\s\+$/]])
      else
        vim.cmd([[match]])
      end
    end

    local function trim_whitespace()
      local save_cursor = vim.fn.getpos(".")
      vim.cmd([[keeppatterns %substitute/\v\s+$//eg]])
      vim.fn.setpos(".", save_cursor)
    end

    vim.api.nvim_create_augroup("whitespace_custom", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "TermOpen", "UIEnter" }, {
      group = "whitespace_custom",
      callback = function()
        vim.schedule(highlight_whitespace)
      end,
    })

    vim.keymap.set("n", "<leader>lw", trim_whitespace, { desc = "Whitespace trim" })
  '';
}
