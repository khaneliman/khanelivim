-- luacheck: globals vim

local function run()
	local count = 0
	local function eq(a, b, label)
		assert(vim.deep_equal(a, b), label .. ": " .. vim.inspect(a))
		count = count + 1
	end
	local snacks = vim.env.CHECK_SNACKS == "1"
	local function press(keys)
		assert(vim.fn.maparg(keys, "n") ~= "", "mapping missing: " .. keys)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "xt", false)
	end
	local function message(text)
		-- Observe real built-in notification history, without replacing vim.notify.
		assert(vim.fn.execute("messages"):find(text, 1, true), "notification missing: " .. text)
		count = count + 1
	end
	vim.cmd("enew!")
	vim.cmd("vsplit")
	local w1 = vim.api.nvim_get_current_win()
	vim.cmd("wincmd w")
	local w2 = vim.api.nvim_get_current_win()
	vim.wo[w1].spell = false
	vim.wo[w2].spell = true
	if not snacks then
		vim.api.nvim_set_current_win(w1)
		vim.g.spell_enabled = true
		press(" ues")
		eq(vim.wo[w1].spell, true, "native spell ignores stale global")
		eq(vim.wo[w2].spell, true, "other window unchanged")
		vim.cmd("setlocal nospell")
		press(" ues")
		eq(vim.wo.spell, true, "manual nospell respected")
		vim.cmd("setlocal spell")
		press(" ues")
		eq(vim.wo.spell, false, "manual spell respected")
		vim.api.nvim_set_current_win(w2)
		press(" ues")
		eq(vim.wo[w2].spell, false, "second window toggle")
		eq(vim.wo[w1].spell, false, "first window unchanged")
		vim.wo.diff = false
		press(" gD")
		eq(vim.wo.diff, true, "native diff on")
		press(" gD")
		eq(vim.wo.diff, false, "native diff off")
	end
	vim.api.nvim_set_current_win(w1)
	vim.wo.foldcolumn = "3"
	vim.cmd("messages clear")
	press(" ueo")
	eq(vim.wo.foldcolumn, "0", "fold column off")
	message("Fold Column off")
	vim.cmd("messages clear")
	press(" ueo")
	eq(vim.wo.foldcolumn, "3", "restore fold column")
	message("Fold Column on")
	vim.wo.foldcolumn = "0"
	vim.g.last_active_foldcolumn = nil
	press(" ueo")
	eq(vim.wo.foldcolumn, "1", "default restored column")
	if not snacks then
		local root = (vim.env.XDG_CACHE_HOME or (vim.fn.getcwd() .. "/.planning")) .. "/khanelivim-tests/native"
		vim.fn.mkdir(root, "p")
		local path = root .. "/trim.txt"
		vim.cmd("enew!")
		vim.api.nvim_buf_set_name(0, path)
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "text  ", "tab\t", "   ", "clean" })
		vim.cmd("write!")
		eq(vim.fn.readfile(path), { "text", "tab", "", "clean" }, "real write strips trailing whitespace")
	end
	io.stdout:write("PASS " .. (snacks and "Snacks folding" or "native") .. ": " .. count .. " assertions", "\n")
end
local ok, err = xpcall(run, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
