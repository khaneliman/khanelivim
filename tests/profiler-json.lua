-- luacheck: globals vim profiler_export

local function run()
	local path = (vim.env.XDG_CACHE_HOME or (vim.fn.getcwd() .. "/.planning")) .. "/khanelivim-tests/profile.json"
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	local name = 'trace\t\r\n"\\' .. string.char(1) .. vim.fn.nr2char(0xe9)
	local plugin = 'plugin\t"\\'
	local tracer = require("snacks.profiler.tracer")
	local load, find = tracer.load, tracer.find
	tracer.load = function() end
	tracer.find = function()
		return { { name = name, plugin = plugin, time = 1234567, count = 2, def = { file = name, line = 3 } } }
	end
	local ok, data = pcall(profiler_export, { format = "json", file = path })
	tracer.load, tracer.find = load, find
	assert(ok, data)
	local decoded = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
	assert(vim.deep_equal(decoded, data), "exported data did not round-trip")
	assert(decoded.traces[1].name == name, "control characters changed")
	assert(decoded.by_plugin[1].name == plugin, "plugin name changed")
	assert(decoded.traces[1].time_ms == 1.234567, "trace precision changed")
	io.stdout:write("PASS profiler JSON round-trip", "\n")
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
