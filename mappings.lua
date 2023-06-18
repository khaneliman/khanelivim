return {
  n = {
    ["<leader><cr>"] = { '<esc>/<++><cr>"_c4l', desc = "Next Template" },
    ["<leader>."] = { "<cmd>Neotree dir=%:p:h<cr>", desc = "Set CWD" },
    -- Telescope
    ["<leader>fe"] = { "<cmd>Telescope file_browser<cr>", desc = "Find in Explorer" },
    ["<leader>fd"] = { "<cmd>Telescope dir live_grep<cr>", desc = "Find relative files" },
    ["<leader>fM"] = { "<cmd>Telescope media_files<cr>", desc = "Find media" },
    ["<leader>fp"] = { "<cmd>Telescope projects<cr>", desc = "Find projects" },
    -- UI
    ["<leader>uz"] = { "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    -- Navigate buffer
    ["<leader>s"] = { name = "Surf / Spectre" },
    ["<leader>lt"] = {
      "<cmd>:%s/\\s\\+$//e<cr>",
      desc = "Trim trailing whitespace",
    },
    -- i = {
    -- 		["<c-d>"] = {
    -- 			n = { "<c-r>=strftime('%Y-%m-%d')<cr>", name = "Y-m-d" },
    -- 			x = { "<c-r>=strftime('%m/%d/%y')<cr>", name = "m/d/y" },
    -- 			f = { "<c-r>=strftime('%B %d, %Y')<cr>", name = "B d, Y" },
    -- 			X = { "<c-r>=strftime('%H:%M')<cr>", name = "H:M" },
    -- 			F = { "<c-r>=strftime('%H:%M:%S')<cr>", name = "H:M:S" },
    -- 			d = { "<c-r>=strftime('%Y/%m/%d %H:%M:%S -')<cr>", name = "Y/m/d H:M:S -" },
    -- 		},
    -- 	},
    -- }
  },
}
