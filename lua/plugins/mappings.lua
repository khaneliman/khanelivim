-- AstroCore provides a central place to modify mappings set up as well as which-key menu titles
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        -- L = {
        --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        --   desc = "Next buffer",
        -- },
        -- H = {
        --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        --   desc = "Previous buffer",
        -- },

        ["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP Information" },
        ["<leader>."] = { "<cmd>Neotree dir=%:p:h<cr>", desc = "Set CWD" },

        -- Telescope
        ["<leader>fe"] = { "<cmd>Telescope file_browser<cr>", desc = "Find in Explorer" },
        ["<leader>fd"] = { "<cmd>Telescope dir live_grep<cr>", desc = "Find relative files" },
        ["<leader>fM"] = { "<cmd>Telescope media_files<cr>", desc = "Find media" },
        ["<leader>fp"] = { "<cmd>Telescope projects<cr>", desc = "Find projects" },

        -- UI
        ["<leader>uz"] = { "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },

        ["<leader>lt"] = {
          "<cmd>:%s/\\s\\+$//e<cr>",
          desc = "Trim trailing whitespace",
        },

        -- mappings seen under group name "Buffer"
        ["<leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
  },
}
