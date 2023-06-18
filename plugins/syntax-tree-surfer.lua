return {
	"ziontee113/syntax-tree-surfer",
	config = function()
		require("syntax-tree-surfer").setup({ highlight_group = "HopNextKey" })
	end,
	keys = {
		{
			"<leader>ss",
			function() require("syntax-tree-surfer").select() end,
			desc = "surf",
		},
		{
			"<leader>sn",
			function() require("syntax-tree-surfer").select_current_node() end,
			desc = "Surf Node",
		},
		{
			"<leader>sv",
			function()
				require("syntax-tree-surfer").targeted_jump {
					"variable_declaration",
				}
			end,
			desc = "Go to Variables",
		},
		{
			"<leader>sF",
			function() require("syntax-tree-surfer").targeted_jump { "function" } end,
			desc = "Go to Functions",
		},
		{
			"<leader>si",
			function()
				require("syntax-tree-surfer").targeted_jump {
					"if_statement",
					"else_clause",
					"else_statement",
					"elseif_statement",
				}
			end,
			desc = "Go to If Statements",
		},
		{
			"<leader>sr",
			function()
				require("syntax-tree-surfer").targeted_jump {
					"for_statement",
				}
			end,
			desc = "Go to For Statements",
		},
		{
			"<leader>sw",
			function()
				require("syntax-tree-surfer").targeted_jump {
					"white_statement",
				}
			end,
			desc = "Go to While Statements",
		},
		{
			"<leader>sc",
			function()
				require("syntax-tree-surfer").targeted_jump {
					"switch_statement",
				}
			end,
			desc = "Go to Switch Statements",
		},
		{
			"<leader>st",
			function()
				require("syntax-tree-surfer").targeted_jump {
					"function",
					"if_statement",
					"else_clause",
					"else_statement",
					"elseif_statement",
					"for_statement",
					"while_statement",
					"switch_statement",
				}
			end,
			desc = "Go to Statement",
		},
	},
	cmd = {
		"STSSelectMasterNode",
		"STSSelectCurrentNode",
		"STSSelectNextSiblingNode",
		"STSSelectPrevSiblingNode",
		"STSSelectParentNode",
		"STSSelectChildNode",
		"STSSwapNextVisual",
		"STSSwapPrevVisuaiw",
	}
}
