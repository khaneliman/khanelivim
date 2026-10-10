-- luacheck: globals vim

local function run()
	local original_cwd = vim.fn.getcwd()
	local root = (vim.env.XDG_CACHE_HOME or (vim.fn.getcwd() .. "/.planning"))
		.. "/khanelivim-tests/gitsigns-"
		.. vim.uv.hrtime()
	vim.fn.mkdir(root, "p")
	local function git(...)
		local command = {
			"git",
			"-C",
			root,
			"-c",
			"core.hooksPath=/dev/null",
			"-c",
			"commit.gpgsign=false",
			"-c",
			"user.name=Fixture",
			"-c",
			"user.email=fixture@example.invalid",
			"--literal-pathspecs",
		}
		vim.list_extend(command, { ... })
		local output = vim.fn.system(command)
		assert(vim.v.shell_error == 0, output)
		return output
	end
	git("-c", "init.templateDir=", "init", "-q")
	local names = {
		"space name.txt",
		"single'quote.txt",
		"meta;touch INJECTED;#.txt",
		"-leading.txt",
		"*.txt",
		":(glob)*.txt",
		"sentinel.txt",
	}
	for _, name in ipairs(names) do
		vim.fn.writefile({ "before" }, root .. "/" .. name)
	end
	git("add", "--all")
	git("commit", "-qm", "fixture")
	for _, name in ipairs(names) do
		vim.fn.writefile({ "after" }, root .. "/" .. name)
	end
	git("add", "--all")
	vim.cmd.cd(vim.fn.fnameescape(root))
	local callback = assert(vim.fn.maparg(" gU", "n", false, true).callback, "unstage mapping missing")
	for index, name in ipairs(names) do
		if name ~= "sentinel.txt" then
			vim.cmd.edit(vim.fn.fnameescape(name))
			callback()
			assert(vim.deep_equal(vim.fn.readfile(root .. "/" .. name), { "after" }), "working file changed")
			local staged = {}
			for _, path in ipairs(vim.split(git("diff", "--cached", "--name-only", "-z"), string.char(1))) do
				staged[path] = true
			end
			assert(not staged[name], "target still staged")
			for remaining = index + 1, #names do
				assert(staged[names[remaining]], "unrelated file unstaged")
			end
		end
	end
	assert(vim.fn.filereadable(root .. "/INJECTED") == 0, "filename executed by shell")
	vim.cmd.cd(vim.fn.fnameescape(original_cwd))
	vim.fn.delete(root, "rf")
	io.stdout:write("PASS literal unstage paths and unchanged worktree\n")
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
