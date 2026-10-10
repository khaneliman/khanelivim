-- luacheck: globals vim

local function run()
	local original_cwd = vim.fn.getcwd()
	local server = original_cwd .. "/tests/fixtures/lsp-server.py"
	local root = (vim.env.XDG_CACHE_HOME or (original_cwd .. "/.planning"))
		.. "/khanelivim-tests/rustowl-"
		.. vim.uv.hrtime()
	vim.fn.mkdir(root, "p")
	vim.fn.writefile({ "[package]", 'name = "fixture"', 'version = "0.1.0"' }, root .. "/Cargo.toml")
	vim.cmd.cd(vim.fn.fnameescape(root))
	local config = require("rustowl.config")
	assert(config.auto_enable, "run against the standard RustOwl configuration")
	local python = vim.fn.exepath("python3")
	assert(python ~= "", "Python 3 is required for the local LSP fixture")
	config.client.cmd = { python, server, "0.6" }
	local ignore = vim.o.eventignore
	vim.opt.eventignore:append("FileType")
	local function buffer(name, filetype)
		local buf = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(buf, root .. "/" .. name)
		vim.bo[buf].filetype = filetype
		return buf
	end
	local markdown = buffer("sample.md", "markdown")
	local rust = buffer("sample.rs", "rust")
	vim.o.eventignore = ignore
	require("rustowl.show-on-hover").enable_on_lsp_attach()
	local foreign = vim.lsp.start({
		name = "fixture-markdown",
		cmd = { python, server, "0.1" },
		root_dir = root,
	}, { bufnr = markdown })
	vim.api.nvim_set_current_buf(rust)
	local rust_id = require("rustowl.lsp").start()
	assert(not vim.lsp.get_client_by_id(rust_id).initialized)
	assert(
		vim.wait(3000, function()
			return vim.lsp.get_client_by_id(foreign).initialized
		end),
		"foreign LSP did not initialize"
	)
	assert(
		vim.wait(3000, function()
			return vim.lsp.get_client_by_id(rust_id).initialized
		end),
		"RustOwl did not initialize"
	)
	assert(not vim.lsp.get_client_by_id(rust_id).attached_buffers[markdown], "RustOwl attached to Markdown")
	assert(require("rustowl").is_enabled(), "RustOwl did not automatically enable")
	for _, map in ipairs(vim.api.nvim_buf_get_keymap(markdown, "n")) do
		assert(not (map.desc or ""):find("RustOwl"), "foreign buffer received RustOwl mappings")
	end
	local maps = {}
	for _, map in ipairs(vim.api.nvim_buf_get_keymap(rust, "n")) do
		maps[map.desc or ""] = map
	end
	assert(maps["Restart RustOwl Client"], "restart mapping missing")
	maps["Disable RustOwl"].callback()
	assert(not require("rustowl").is_enabled())
	maps["Enable RustOwl"].callback()
	assert(require("rustowl").is_enabled())
	require("rustowl").disable(rust)
	vim.lsp.stop_client({ foreign, rust_id }, true)
	vim.wait(100)
	vim.cmd.cd(vim.fn.fnameescape(original_cwd))
	vim.fn.delete(root, "rf")
	io.stdout:write("PASS RustOwl attachment ownership and controls\n")
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
