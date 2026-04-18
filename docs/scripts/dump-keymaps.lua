-- luacheck: globals vim

local output_path = vim.env.KEYMAPS_OUTPUT
local sample_dir = vim.env.KEYMAPS_SAMPLE_DIR

if not output_path or output_path == "" then
	error("KEYMAPS_OUTPUT is required")
end

if not sample_dir or sample_dir == "" then
	error("KEYMAPS_SAMPLE_DIR is required")
end

local modes = { "n", "v", "x", "s", "o", "i", "t", "c" }

local sample_files = {
	{ path = "sample.lua", lines = { "local value = 1", "print(value)" } },
	{ path = "sample.nix", lines = { "{ pkgs, ... }:", "{", "}" } },
	{ path = "sample.md", lines = { "# Sample", "", "- item" } },
	{ path = "sample.ts", lines = { "export const value = 1;", "console.log(value);" } },
	{ path = "sample.py", lines = { "value = 1", "print(value)" } },
	{ path = "sample.rs", lines = { "fn main() {", '    println!("hello");', "}" } },
}

local root_files = {
	{ path = "package.json", lines = { '{ "name": "khanelivim-keymaps" }' } },
	{ path = "tsconfig.json", lines = { "{", '  "compilerOptions": {}', "}" } },
	{ path = "pyproject.toml", lines = { "[project]", 'name = "khanelivim-keymaps"', 'version = "0.1.0"' } },
	{
		path = "Cargo.toml",
		lines = { "[package]", 'name = "khanelivim-keymaps"', 'version = "0.1.0"', 'edition = "2021"' },
	},
}

local function joinpath(...)
	return vim.fs.joinpath(...)
end

local function write_lines(path, lines)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	vim.fn.writefile(lines, path)
end

local function normalize_rhs(map)
	if type(map.rhs) == "string" and map.rhs ~= "" then
		return map.rhs
	end

	return nil
end

local function map_payload(mode, map, scope, filetype)
	return {
		mode = mode,
		scope = scope,
		filetype = filetype,
		lhs = map.lhs,
		rhs = normalize_rhs(map),
		desc = map.desc,
		expr = map.expr == 1,
		noremap = map.noremap == 1,
		nowait = map.nowait == 1,
		silent = map.silent == 1,
	}
end

for _, root in ipairs(root_files) do
	write_lines(joinpath(sample_dir, root.path), root.lines)
end

for _, sample in ipairs(sample_files) do
	write_lines(joinpath(sample_dir, sample.path), sample.lines)
end

local buffers = {}
local warnings = {}

for _, sample in ipairs(sample_files) do
	local full_path = joinpath(sample_dir, sample.path)
	local ok, err = pcall(vim.cmd.edit, vim.fn.fnameescape(full_path))
	if ok then
		vim.cmd("silent doautocmd <nomodeline> BufEnter")
		vim.wait(150)
		local bufnr = vim.api.nvim_get_current_buf()
		buffers[#buffers + 1] = {
			bufnr = bufnr,
			filetype = vim.bo[bufnr].filetype,
			path = full_path,
		}
	else
		-- Keep the dump best-effort. A single problematic filetype should not
		-- abort the docs build.
		warnings[#warnings + 1] = string.format("failed to open %s: %s", sample.path, err)
	end
end

vim.wait(300)

local payload = {
	profile = "standard",
	generatedAt = os.date("!%Y-%m-%dT%H:%M:%SZ"),
	warnings = warnings,
	sampleFiletypes = vim.tbl_map(function(buf)
		return buf.filetype
	end, buffers),
	maps = {},
}

for _, mode in ipairs(modes) do
	for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
		payload.maps[#payload.maps + 1] = map_payload(mode, map, "global", nil)
	end
end

for _, buf in ipairs(buffers) do
	for _, mode in ipairs(modes) do
		for _, map in ipairs(vim.api.nvim_buf_get_keymap(buf.bufnr, mode)) do
			payload.maps[#payload.maps + 1] = map_payload(mode, map, "buffer", buf.filetype)
		end
	end
end

write_lines(output_path, vim.split(vim.json.encode(payload), "\n", { plain = true }))
