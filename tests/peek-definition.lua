-- luacheck: globals vim

local function run()
	local count = 0
	local function eq(a, b, label)
		assert(vim.deep_equal(a, b), label .. ": " .. vim.inspect(a))
		count = count + 1
	end
	assert(vim.fn.exists(":PeekDefinition") == 2, "candidate command not installed")
	local root = (vim.env.XDG_CACHE_HOME or (vim.fn.getcwd() .. "/.planning")) .. "/khanelivim-tests/peek"
	vim.fn.mkdir(root, "p")
	local target = root .. "/target.lua"
	vim.fn.writefile({ "local target = true", "return target" }, target)
	vim.cmd("enew!")
	local source = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_name(source, root .. "/source.lua")
	vim.bo[source].filetype = "lua"
	vim.api.nvim_buf_set_lines(source, 0, -1, false, { "a" .. vim.fn.nr2char(0x1f600) .. vim.fn.nr2char(0xe9) .. "x" })
	vim.api.nvim_win_set_cursor(0, { 1, 7 })
	local callback
	local original = vim.lsp.buf_request
	vim.lsp.buf_request = function(buf, method, params, cb)
		eq(buf, 0, "current buffer request")
		eq(method, "textDocument/definition", "method")
		eq(type(params), "function", "per-client params")
		eq(params({ offset_encoding = "utf-8" }).position.character, 7, "UTF-8 byte offset")
		eq(params({ offset_encoding = "utf-16" }).position.character, 4, "UTF-16 code-unit offset")
		callback = cb
	end
	local ok, err = pcall(vim.cmd, "PeekDefinition textDocument/definition")
	vim.lsp.buf_request = original
	assert(ok, err)
	assert(callback, "no LSP callback")
	local range = { start = { line = 0, character = 0 }, ["end"] = { line = 1, character = 0 } }
	local location = { uri = vim.uri_from_fname(target), range = range }
	local link = { targetUri = location.uri, targetRange = range, targetSelectionRange = range }
	local function preview(result, label)
		local before = vim.api.nvim_list_wins()
		callback(nil, result)
		local after = vim.api.nvim_list_wins()
		eq(#after, #before + 1, label .. " opens real preview")
		local win
		for _, w in ipairs(after) do
			if not vim.tbl_contains(before, w) then
				win = w
			end
		end
		local buf = vim.api.nvim_win_get_buf(win)
		eq(
			vim.api.nvim_buf_get_lines(buf, 0, -1, false),
			{ "local target = true", "return target" },
			label .. " content"
		)
		eq(vim.bo[buf].filetype, "lua", label .. " inherits filetype")
		vim.api.nvim_win_close(win, true)
	end
	preview(location, "Location")
	preview({ location }, "Location[]")
	preview({ link }, "LocationLink[]")
	for _, result in ipairs({ {}, { false } }) do
		local before = #vim.api.nvim_list_wins()
		callback(nil, result)
		eq(#vim.api.nvim_list_wins(), before, "empty/no location has no preview")
	end
	local before = #vim.api.nvim_list_wins()
	callback(nil, nil)
	eq(#vim.api.nvim_list_wins(), before, "nil result has no preview")
	io.stdout:write("PASS peek: " .. count .. " assertions; actual Neovim preview APIs", "\n")
end
local ok, err = xpcall(run, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
