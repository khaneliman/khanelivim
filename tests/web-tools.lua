-- luacheck: globals vim

local function run()
	local root = (vim.env.XDG_CACHE_HOME or (vim.fn.getcwd() .. "/.planning")) .. "/khanelivim-tests/web"
	vim.fn.delete(root, "rf")
	vim.fn.mkdir(root, "p")
	local count = 0
	local function eq(actual, expected, label)
		assert(vim.deep_equal(actual, expected), label .. ": " .. vim.inspect(actual))
		count = count + 1
	end
	local function write(path, text)
		vim.fn.mkdir(vim.fs.dirname(path), "p")
		vim.fn.writefile({ text }, path)
	end
	local function module()
		package.loaded["khanelivim.web_tools"] = nil
		return require("khanelivim.web_tools")
	end
	local function buffer(name)
		local b = vim.api.nvim_create_buf(true, false)
		if name then
			write(name, "const x = 1")
			vim.api.nvim_buf_set_name(b, name)
		end
		return b
	end
	local b = buffer(root .. "/sibling/index.js")
	write(root .. "/sibling/package.json", '{"eslintConfig":{},"prettier":{}}')
	local m = module()
	eq(m.detect(b).eslint, root .. "/sibling/package.json", "same-directory eslintConfig")
	eq(m.detect(b).prettier, root .. "/sibling/package.json", "same-directory prettier")
	local nested = buffer(root .. "/sibling/src/deep/index.js")
	eq(m.detect(nested).eslint, root .. "/sibling/package.json", "ancestor config")
	write(root .. "/sibling/src/package.json", '{"eslintConfig":{},"prettier":{}}')
	m = module()
	eq(m.detect(nested).eslint, root .. "/sibling/src/package.json", "nearest ancestor package")
	write(root .. "/sibling/src/deep/.eslintrc.json", "{}")
	write(root .. "/sibling/src/deep/.prettierrc", "{}")
	eq(m.detect(nested).eslint, root .. "/sibling/src/deep/.eslintrc.json", "explicit eslint precedence")
	eq(m.detect(nested).prettier, root .. "/sibling/src/deep/.prettierrc", "explicit prettier precedence")
	eq(m.preferred_formatters(nested, "javascript").owner, "prettier", "prettier owner")
	write(root .. "/sibling/src/deep/biome.jsonc", "{}")
	eq(m.preferred_formatters(nested, "javascript").owner, "biome", "biome formatter precedence")
	eq(m.preferred_diagnostics_owner(nested), "biome", "biome diagnostics precedence")
	local malformed = buffer(root .. "/sibling/broken/index.js")
	write(root .. "/sibling/broken/package.json", "{broken")
	m = module()
	eq(m.detect(malformed).eslint, root .. "/sibling/package.json", "malformed JSON falls back to ancestor")
	local empty = buffer(root .. "/empty/index.js")
	eq(m.detect(empty), {}, "no configs")
	eq(m.preferred_formatters(empty, "javascript").owner, "fallback", "JS fallback")
	eq(m.preferred_formatters(empty, "css").owner, "stylelint", "CSS fallback")
	local unnamed = buffer()
	eq(m.detect(unnamed), {}, "unnamed buffer")
	vim.api.nvim_set_current_buf(unnamed)
	eq(m.detect(0), {}, "current unnamed buffer")
	local invalid = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_delete(invalid, { force = true })
	local ok = pcall(m.detect, invalid)
	eq(ok, false, "deleted buffer rejected by Neovim API (not silently accepted)")
	io.stdout:write("PASS web: " .. count .. " assertions", "\n")
end
local ok, err = xpcall(run, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
