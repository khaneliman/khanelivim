-- Example customization of Treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "RRethy/nvim-treesitter-endwise" },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    opts.endwise = { enable = true }
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = astrocore.list_insert_unique(opts.ensure_installed, {
      "bash",
      "c_sharp",
      "cpp",
      "css",
      "diff",
      "dockerfile",
      "fish",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "html",
      "javascript",
      "jq",
      "json",
      "jsonc",
      "llvm",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "rasi",
      "regex",
      "rust",
      "sql",
      "typescript",
      "vim",
      "yaml",
    })
  end,
}
