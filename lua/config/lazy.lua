local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.g.astronvim_first_install = true -- lets AstroNvim know that this is an initial installation
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- TODO: set to true on release
-- Whether or not to use stable releases of AstroNvim
local USE_STABLE = false

local spec = {
  -- TODO: remove branch v4 on release
  { "AstroNvim/AstroNvim", branch = "v4", version = USE_STABLE and "*" or nil, import = "astronvim.plugins" },
  -- { "AstroNvim/AstroNvim", version = "3.x", import = "astronvim.plugins" }, -- use this line to only get updates for v3 and avoid the breaking changes if v4 is released
}
if USE_STABLE then table.insert(spec, { import = "astronvim.lazy_snapshot" }) end -- pin plugins to known stable versions/commits

require("lazy").setup {
  spec = vim.list_extend(spec, {
    -- AstroCommunity import any community modules here
    -- TODO: Remove branch v4 on release
    { "AstroNvim/astrocommunity", branch = "v4" },
    -- Code refactoring
    -- { import = "astrocommunity.editing-support.refactoring-nvim" },

    -- Improved Yank
    -- FIX: nixos broken
    -- { import = "astrocommunity.editing-support.yanky-nvim" },

    -- Idle animation
    -- FIX: doesn't work with transparent background
    -- { import = "astrocommunity.media.drop-nvim" },

    -- Org-like
    -- { import = "astrocommunity.note-taking/neorg" },

    -- Language Packs
    { import = "astrocommunity.pack.angular" },
    { import = "astrocommunity.pack.bash" },
    { import = "astrocommunity.pack.cpp" },
    { import = "astrocommunity.pack.cmake" },
    { import = "astrocommunity.pack.docker" },
    { import = "astrocommunity.pack.html-css" },
    { import = "astrocommunity.pack.java" },
    { import = "astrocommunity.pack.json" },
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.pack.markdown" },
    -- { import = "astrocommunity.pack.nix" },
    { import = "astrocommunity.pack.python" },
    { import = "astrocommunity.pack.rust" },
    { import = "astrocommunity.pack.toml" },
    { import = "astrocommunity.pack.typescript-all-in-one" },
    { import = "astrocommunity.pack.yaml" },

    -- Syntax highlighting
    -- { import = "astrocommunity.syntax.hlargs-nvim" },

    { import = "plugins" }, -- import/override with your plugins
  }),
  defaults = {
    -- By default, only AstroNvim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
  },
  install = { colorscheme = { "catppuccin", "astrodark", "habamax" } },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
  },
}
