-- luacheck: globals vim

local M = {}

local biome_config_files = {
	"biome.json",
	"biome.jsonc",
}

local eslint_config_files = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
}

local prettier_config_files = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.mjs",
	".prettierrc.toml",
	"prettier.config.js",
	"prettier.config.cjs",
	"prettier.config.mjs",
	"prettier.config.ts",
	"prettier.config.cts",
	"prettier.config.mts",
}

local js_like = {
	javascript = true,
	javascriptreact = true,
	typescript = true,
	typescriptreact = true,
}

local html_like = {
	html = true,
}

local css_like = {
	css = true,
	scss = true,
	sass = true,
}

local package_json_cache = {}

local function get_buf_path(bufnr)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return nil
	end
	return name
end

local function read_json(path)
	if package_json_cache[path] ~= nil then
		return package_json_cache[path]
	end

	local f = io.open(path, "r")
	if not f then
		package_json_cache[path] = false
		return nil
	end

	local ok, decoded = pcall(vim.json.decode, f:read("*a"))
	f:close()
	package_json_cache[path] = ok and decoded or false
	return ok and decoded or nil
end

local function find_upward(path, names)
	local found = vim.fs.find(names, {
		path = path,
		type = "file",
		limit = 1,
		upward = true,
	})[1]
	return found
end

local function package_json_has_key(path, key)
	local dir = vim.fs.dirname(path)
	for parent in vim.fs.parents(dir) do
		local package_json = vim.fs.joinpath(parent, "package.json")
		if vim.uv.fs_stat(package_json) then
			local decoded = read_json(package_json)
			if decoded and decoded[key] ~= nil then
				return package_json
			end
		end
	end
	return nil
end

function M.detect(bufnr)
	local path = get_buf_path(bufnr)
	if not path then
		return {
			biome = nil,
			eslint = nil,
			prettier = nil,
		}
	end

	return {
		biome = find_upward(path, biome_config_files) or package_json_has_key(path, "biomejs"),
		eslint = find_upward(path, eslint_config_files) or package_json_has_key(path, "eslintConfig"),
		prettier = find_upward(path, prettier_config_files) or package_json_has_key(path, "prettier"),
	}
end

function M.preferred_formatters(bufnr, filetype)
	local detected = M.detect(bufnr)

	if detected.biome then
		return {
			formatters = { "biome", stop_after_first = true },
			owner = "biome",
			config = detected.biome,
		}
	end

	if detected.prettier and (js_like[filetype] or html_like[filetype] or css_like[filetype]) then
		return {
			formatters = { "prettierd", stop_after_first = true },
			owner = "prettier",
			config = detected.prettier,
		}
	end

	if js_like[filetype] then
		return {
			formatters = { "biome", "prettierd", stop_after_first = true },
			owner = "fallback",
			config = nil,
		}
	end

	if html_like[filetype] then
		return {
			formatters = { "prettierd" },
			owner = detected.prettier and "prettier" or "fallback",
			config = detected.prettier,
		}
	end

	if css_like[filetype] then
		return {
			formatters = { "stylelint" },
			owner = "stylelint",
			config = nil,
		}
	end

	return nil
end

function M.describe(bufnr)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
	local filetype = vim.bo[bufnr].filetype
	local detected = M.detect(bufnr)
	local preferred = M.preferred_formatters(bufnr, filetype)

	return {
		diagnostics_owner = M.preferred_diagnostics_owner(bufnr),
		filetype = filetype,
		detected = detected,
		preferred = preferred,
	}
end

function M.preferred_diagnostics_owner(bufnr)
	local detected = M.detect(bufnr)

	if detected.biome then
		return "biome"
	end

	if detected.eslint then
		return "eslint"
	end

	return nil
end

return M
