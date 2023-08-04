return {
	-- disabled = {
	-- 	"alejandra",
	-- },
	filter = function(client)
		if client.name == "null_ls" then
			if vim.bo.filetype == "nix" then
				return false
			end
		end

		-- enable all other clients
		return true
	end,
}
