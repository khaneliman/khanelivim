return {
	"goolord/alpha-nvim",
	opts = function(_, opts)
		local utils = require("astronvim.utils")
		-- customize the dashboard header
		opts.section.header.val = {
			"                                                       ",
			"                                                       ",
			"                                                       ",
			" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
			" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
			" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
			" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
			" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
			" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
			"                                                       ",
			"                                                       ",
			"                                                       ",
			"                                                       ",
		}
		opts.section.buttons.val = {
			utils.alpha_button("LDR f f", "  Find File  "),
			utils.alpha_button("LDR f o", "  Recents  "),
			utils.alpha_button("LDR f p", "P  Projects  "),
			utils.alpha_button("LDR f n", "  New File  "),
			utils.alpha_button("LDR S l", "  Last Session  "),
		}

		return opts
	end,
}
