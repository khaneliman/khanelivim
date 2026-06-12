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
  '';
}
