-- luacheck: globals vim

local M = {}

local compatibility_keymaps_set = {}
local diagnostics_were_enabled = {}
local ours_marker = "^<<<<<<<+"

local compatibility_keymaps = {
	["[x"] = {
		action = "<cmd>ResolvePrev<CR>",
		desc = "Previous conflict",
		modes = { "n" },
	},
	["]x"] = {
		action = "<cmd>ResolveNext<CR>",
		desc = "Next conflict",
		modes = { "n" },
	},
	c0 = {
		action = "<cmd>ResolveNone<CR>",
		desc = "Choose none",
		modes = { "n", "v" },
	},
	cb = {
		action = "<cmd>ResolveBoth<CR>",
		desc = "Choose both",
		modes = { "n", "v" },
	},
	co = {
		action = "<cmd>ResolveOurs<CR>",
		desc = "Choose ours",
		modes = { "n", "v" },
	},
	ct = {
		action = "<cmd>ResolveTheirs<CR>",
		desc = "Choose theirs",
		modes = { "n", "v" },
	},
}

local function set_compatibility_keymaps(bufnr)
	for key, mapping in pairs(compatibility_keymaps) do
		vim.keymap.set(mapping.modes, key, mapping.action, {
			buffer = bufnr,
			desc = mapping.desc,
			silent = true,
		})
	end
	compatibility_keymaps_set[bufnr] = true
end

local function remove_compatibility_keymaps(bufnr)
	if not compatibility_keymaps_set[bufnr] then
		return
	end

	for key, mapping in pairs(compatibility_keymaps) do
		for _, mode in ipairs(mapping.modes) do
			pcall(vim.keymap.del, mode, key, { buffer = bufnr })
		end
	end
	compatibility_keymaps_set[bufnr] = nil
end

local function loaded_buffer_lines()
	local buffers = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name ~= "" then
				buffers[vim.fs.normalize(name)] = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			end
		end
	end

	return buffers
end

local function read_lines(path, buffers)
	local lines = buffers[vim.fs.normalize(path)]
	if lines then
		return lines
	end

	local ok, file_lines = pcall(vim.fn.readfile, path)
	return ok and file_lines or {}
end

local function git(args, opts)
	local command = vim.list_extend({ "git" }, args)
	local result = vim.system(command, opts or { text = true }):wait()

	if result.code ~= 0 then
		local message = vim.trim(result.stderr or "")
		return nil, message ~= "" and message or "git exited with code " .. result.code
	end

	return result.stdout or ""
end

local function git_root_from(directory)
	local root, err = git({ "-C", directory, "rev-parse", "--show-toplevel" })
	if not root then
		return nil, err
	end

	return vim.trim(root)
end

local function git_root()
	local filename = vim.api.nvim_buf_get_name(0)
	if vim.bo.buftype == "" and filename ~= "" then
		local directory = vim.fs.dirname(filename)
		if directory then
			local root = git_root_from(directory)
			if root then
				return root
			end
		end
	end

	local directory = vim.uv.cwd()
	if not directory then
		return nil, "current directory is unavailable"
	end

	return git_root_from(directory)
end

function M.next_conflict()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for line_number = current_line + 1, #lines do
		if lines[line_number]:match(ours_marker) then
			vim.api.nvim_win_set_cursor(0, { line_number, 0 })
			return
		end
	end

	for line_number = 1, current_line do
		if lines[line_number]:match(ours_marker) then
			vim.api.nvim_win_set_cursor(0, { line_number, 0 })
			return
		end
	end

	vim.notify("No conflicts found", vim.log.levels.INFO)
end

function M.prev_conflict()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for line_number = current_line - 1, 1, -1 do
		if lines[line_number]:match(ours_marker) then
			vim.api.nvim_win_set_cursor(0, { line_number, 0 })
			return
		end
	end

	for line_number = #lines, current_line, -1 do
		if lines[line_number]:match(ours_marker) then
			vim.api.nvim_win_set_cursor(0, { line_number, 0 })
			return
		end
	end

	vim.notify("No conflicts found", vim.log.levels.INFO)
end

function M.list_conflicts()
	local root, root_err = git_root()
	if not root then
		vim.notify("ResolveList: " .. root_err, vim.log.levels.WARN)
		return
	end

	local output, diff_err = git({ "-C", root, "diff", "--name-only", "--diff-filter=U", "-z" }, { text = false })
	if not output then
		vim.notify("ResolveList: " .. diff_err, vim.log.levels.ERROR)
		return
	end

	local items = {}
	local buffers = loaded_buffer_lines()
	local paths = vim.split(output, "\0", { plain = true, trimempty = true })

	for _, relative_path in ipairs(paths) do
		local path = vim.fs.joinpath(root, relative_path)
		local lines = read_lines(path, buffers)
		local marker_found = false

		for line_number, line in ipairs(lines) do
			if line:match(ours_marker) then
				marker_found = true
				table.insert(items, {
					filename = path,
					lnum = line_number,
					text = line,
				})
			end
		end

		if not marker_found then
			table.insert(items, {
				filename = path,
				lnum = 1,
				text = "Unmerged file without conflict markers",
			})
		end
	end

	vim.fn.setqflist({}, "r", {
		title = "Git conflicts",
		items = items,
	})

	if #items == 0 then
		vim.notify("No unresolved Git conflicts found", vim.log.levels.INFO)
		return
	end

	vim.cmd.copen()
end

local function create_compatibility_commands(resolve)
	local commands = {
		GitConflictChooseBase = resolve.choose_base,
		GitConflictChooseBoth = resolve.choose_both,
		GitConflictChooseNone = resolve.choose_none,
		GitConflictChooseOurs = resolve.choose_ours,
		GitConflictChooseTheirs = resolve.choose_theirs,
		GitConflictListQf = M.list_conflicts,
		GitConflictNextConflict = M.next_conflict,
		GitConflictPrevConflict = M.prev_conflict,
		GitConflictRefresh = resolve.detect_conflicts,
		ResolveList = M.list_conflicts,
		ResolveNext = M.next_conflict,
		ResolvePrev = M.prev_conflict,
	}

	for name, callback in pairs(commands) do
		vim.api.nvim_create_user_command(name, callback, {
			desc = "Compatibility alias provided by resolve.nvim",
			force = true,
		})
	end
end

function M.setup(settings, disable_diagnostics)
	local resolve = require("resolve")
	local options = vim.deepcopy(settings or {})
	local on_conflict_detected = options.on_conflict_detected
	local on_conflicts_resolved = options.on_conflicts_resolved
	if options.markers and options.markers.ours then
		ours_marker = options.markers.ours
	end

	options.default_keymaps = false
	options.on_conflict_detected = function(data)
		set_compatibility_keymaps(data.bufnr)

		if disable_diagnostics and diagnostics_were_enabled[data.bufnr] == nil then
			diagnostics_were_enabled[data.bufnr] = vim.diagnostic.is_enabled({ bufnr = data.bufnr })
			vim.diagnostic.enable(false, { bufnr = data.bufnr })
		end

		if on_conflict_detected then
			on_conflict_detected(data)
		end
	end
	options.on_conflicts_resolved = function(data)
		remove_compatibility_keymaps(data.bufnr)

		if disable_diagnostics and diagnostics_were_enabled[data.bufnr] then
			vim.diagnostic.enable(true, { bufnr = data.bufnr })
		end
		diagnostics_were_enabled[data.bufnr] = nil

		if on_conflicts_resolved then
			on_conflicts_resolved(data)
		end
	end

	resolve.setup(options)
	create_compatibility_commands(resolve)

	local augroup = vim.api.nvim_create_augroup("KhanelivimResolve", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = augroup,
		callback = function(args)
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_call(args.buf, resolve.detect_conflicts)
			end
		end,
	})

	if vim.bo.buftype == "" then
		resolve.detect_conflicts()
	end
end

return M
