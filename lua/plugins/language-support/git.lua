return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = astrocore.list_insert_unique(opts.ensure_installed, {
      "diff",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
    })
  end,
}
