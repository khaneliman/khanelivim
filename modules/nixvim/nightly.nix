_: {
  extraConfigLua = ''
    if vim.fn.has("nvim-0.12") == 1 then
      vim.opt.completeitemalign = "abbr,kind,menu"
      vim.opt.jumpoptions = "stack"
      vim.opt.pumborder = "single"
      vim.opt.pummaxwidth = 100
      vim.opt.completetimeout = 100
      vim.opt.diffopt:append("inline:word")
    end

    if vim.fn.has("nvim-0.13") == 1 then
      vim.opt.shortmess:append("u")
      vim.opt.scrolloffpad = 1
    end

    if vim.hl and vim.hl.hl_op then
      local group = vim.api.nvim_create_augroup("khanelivim_nightly_highlight", { clear = true })
      vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
        group = group,
        callback = function()
          vim.hl.hl_op({ higroup = "Visual", timeout = 180 })
        end,
      })
    end
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>uR";
      action.__raw = ''
        function()
          if vim.fn.exists(":restart") ~= 2 then
            vim.notify(":restart requires Nvim 0.12+", vim.log.levels.WARN)
            return
          end

          vim.cmd("restart")
        end
      '';
      options.desc = "Restart Nvim";
    }
    {
      mode = "n";
      key = "<leader>ul";
      action.__raw = ''
        function()
          if vim.fn.exists(":log") ~= 2 then
            vim.notify(":log requires Nvim 0.13+", vim.log.levels.WARN)
            return
          end

          vim.cmd("log")
        end
      '';
      options.desc = "Open logs";
    }
  ];
}
