return {
  "saimo/peek.nvim",
  build = "deno task --quiet build:fast",
  config = function()
    require("peek").setup()
    -- refer to `configuration to change defaults`
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  end,
  cmd = {
    "PeekOpen",
    "PeekClose",
  },
}
