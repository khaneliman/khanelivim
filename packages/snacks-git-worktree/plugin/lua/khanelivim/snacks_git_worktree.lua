-- luacheck: globals vim

local M = {}

local path_separator = package.config:sub(1, 1)

local function normalize_path(path)
	if path == nil or path == "" then
		return nil
	end

	return vim.loop.fs_realpath(path) or path
end

local function parse_git_worktree_output(raw)
	local entries = {}
	local i = 1

	while i <= #raw do
		local line = raw[i]
		if line:match("^worktree %s*") then
			local entry = {
				path = vim.trim(line:sub(9)),
			}

			i = i + 1
			while i <= #raw and raw[i] ~= "" do
				if raw[i]:match("^branch ") then
					entry.branch = vim.trim(raw[i]:sub(8))
				end
				i = i + 1
			end

			table.insert(entries, entry)
		else
			i = i + 1
		end
	end

	return entries
end

local function list_worktrees()
	local output = vim.fn.systemlist("git worktree list --porcelain")
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to list git worktrees", vim.log.levels.WARN)
		return {}
	end

	return parse_git_worktree_output(output)
end

local function current_worktree_root()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 or git_root == nil or git_root == "" then
		return nil
	end

	return normalize_path(git_root)
end

local function resolve_path(path, base)
	if path == nil or path == "" then
		return nil
	end

	if vim.fn.fnamemodify(path, ":p") == path then
		return normalize_path(path) or path
	end

	return normalize_path(base .. path_separator .. path) or (base .. path_separator .. path)
end

local function branch_label(branch, fallback)
	local name = (branch or ""):gsub("^refs/heads/", "")
	if name == "" then
		return fallback
	end

	return name
end

local function format_worktree_item(item)
	local suffix = item.current and " (current)" or ""
	return string.format("%s%s\t%s", branch_label(item.branch, item.path), suffix, item.path)
end

local function prompt_input(opts, on_confirm)
	vim.ui.input(opts, function(value)
		if value == nil then
			return
		end

		on_confirm(vim.trim(value))
	end)
end

local function branch_exists(branch)
	local output = vim.fn.systemlist({
		"git",
		"branch",
		"--list",
		"--format=%(refname:short)",
		branch,
	})
	if vim.v.shell_error ~= 0 then
		return false
	end

	for _, line in ipairs(output) do
		if vim.trim(line) == branch then
			return true
		end
	end

	return false
end

local function run_git(args, cwd, on_success)
	if vim.system == nil then
		vim.notify("vim.system is unavailable", vim.log.levels.ERROR)
		return
	end

	vim.system(
		vim.list_extend({ "git" }, args),
		{
			cwd = cwd,
			text = true,
		},
		vim.schedule_wrap(function(result)
			if result.code ~= 0 then
				local stderr = vim.trim(result.stderr or "")
				local stdout = vim.trim(result.stdout or "")
				local message = stderr ~= "" and stderr or stdout
				if message == "" then
					message = "git " .. table.concat(args, " ") .. " failed"
				end

				vim.notify(message, vim.log.levels.ERROR)
				return
			end

			if on_success ~= nil then
				on_success(result)
			end
		end)
	)
end

local function relative_to_root(path, root)
	local absolute_path = normalize_path(path)
	local absolute_root = normalize_path(root)

	if absolute_path == nil or absolute_root == nil then
		return nil
	end

	if absolute_path == absolute_root then
		return ""
	end

	local prefix = absolute_root .. path_separator
	if absolute_path:sub(1, #prefix) ~= prefix then
		return nil
	end

	return absolute_path:sub(#prefix + 1)
end

local function set_worktree_directory(path, source_win)
	local escaped_path = vim.fn.fnameescape(path)

	vim.api.nvim_set_current_dir(path)
	pcall(vim.cmd, "tcd " .. escaped_path)

	if source_win ~= nil and vim.api.nvim_win_is_valid(source_win) then
		vim.api.nvim_win_call(source_win, function()
			pcall(vim.cmd, "lcd " .. escaped_path)
		end)
	end
end

local function edit_path_in_window(path, source_ctx)
	if source_ctx == nil or source_ctx.win == nil or not vim.api.nvim_win_is_valid(source_ctx.win) then
		return
	end

	vim.api.nvim_win_call(source_ctx.win, function()
		local command = "edit "
		if source_ctx.buf ~= nil and vim.api.nvim_buf_is_valid(source_ctx.buf) and vim.bo[source_ctx.buf].modified then
			command = "confirm edit "
		end

		vim.cmd(command .. vim.fn.fnameescape(path))
	end)
end

local function switch_to_worktree(path, source_ctx)
	local target_root = normalize_path(path)
	if target_root == nil or vim.loop.fs_stat(target_root) == nil then
		vim.notify("Worktree path does not exist: " .. tostring(path), vim.log.levels.ERROR)
		return
	end

	local previous_root = current_worktree_root()
	if previous_root == nil then
		vim.notify("Failed to detect current git worktree", vim.log.levels.ERROR)
		return
	end

	if target_root == previous_root then
		vim.notify("Already in worktree: " .. target_root, vim.log.levels.INFO)
		return
	end

	set_worktree_directory(target_root, source_ctx and source_ctx.win or nil)

	local relative_name = source_ctx and relative_to_root(source_ctx.buf_name, previous_root) or nil
	if relative_name == nil then
		vim.notify("Switched to worktree: " .. target_root, vim.log.levels.INFO)
		return
	end

	local target_path = relative_name == "" and target_root or (target_root .. path_separator .. relative_name)
	if vim.loop.fs_stat(target_path) == nil then
		vim.notify("Switched to worktree: " .. target_root, vim.log.levels.INFO)
		return
	end

	edit_path_in_window(target_path, source_ctx)
end

local function current_source_context()
	return {
		win = vim.api.nvim_get_current_win(),
		buf = vim.api.nvim_get_current_buf(),
		buf_name = vim.api.nvim_buf_get_name(0),
	}
end

local function get_snacks()
	local ok, snacks = pcall(require, "snacks")
	if not ok or type(snacks) ~= "table" then
		vim.notify("snacks.nvim is not loaded", vim.log.levels.ERROR)
		return nil
	end

	return snacks
end

local function worktree_items()
	local current = current_worktree_root()
	local items = {}

	for _, tree in ipairs(list_worktrees()) do
		local path = tree.path
		local real_path = vim.loop.fs_realpath(path) or path

		table.insert(items, {
			path = path,
			branch = tree.branch or path,
			current = current ~= nil and real_path == current,
		})
	end

	return items
end

local function create_worktree(source_ctx)
	local current_root = current_worktree_root()
	if current_root == nil then
		vim.notify("Failed to detect current git worktree", vim.log.levels.ERROR)
		return
	end

	prompt_input({ prompt = "Worktree branch: " }, function(branch)
		if branch == "" then
			vim.notify("Worktree creation cancelled", vim.log.levels.INFO)
			return
		end

		local parent_dir = vim.fn.fnamemodify(current_root, ":h")
		local repo_name = vim.fn.fnamemodify(current_root, ":t")
		local branch_slug = branch:gsub("[^%w._-]", "-")
		local default_path = parent_dir .. path_separator .. repo_name .. "-" .. branch_slug

		prompt_input({
			prompt = "Worktree path: ",
			default = default_path,
			completion = "dir",
		}, function(path)
			if path == "" then
				vim.notify("Worktree creation cancelled", vim.log.levels.INFO)
				return
			end

			local target_path = resolve_path(path, current_root)
			local args = { "worktree", "add" }
			if branch_exists(branch) then
				vim.list_extend(args, {
					target_path,
					branch,
				})
			else
				vim.list_extend(args, {
					"-b",
					branch,
					target_path,
				})
			end

			run_git(args, current_root, function()
				switch_to_worktree(target_path, source_ctx)
			end)
		end)
	end)
end

local function delete_worktree(items, current_root)
	local snacks = get_snacks()
	if snacks == nil then
		return
	end

	local candidates = {}
	for _, item in ipairs(items) do
		if not item.current then
			table.insert(candidates, item)
		end
	end

	if #candidates == 0 then
		vim.notify("No deletable git worktrees found", vim.log.levels.INFO)
		return
	end

	snacks.picker.select(candidates, {
		prompt = "Remove Git Worktree",
		format_item = format_worktree_item,
	}, function(item)
		if item == nil or item.path == nil then
			return
		end

		vim.schedule(function()
			snacks.picker.select({
				{
					label = "Cancel",
					force = nil,
				},
				{
					label = "Remove",
					force = false,
				},
				{
					label = "Force Remove",
					force = true,
				},
			}, {
				prompt = "Remove " .. branch_label(item.branch, item.path),
				format_item = function(choice)
					return string.format("%s\t%s", choice.label, item.path)
				end,
			}, function(choice)
				if choice == nil or choice.force == nil then
					return
				end

				local args = { "worktree", "remove" }
				if choice.force then
					table.insert(args, "--force")
				end
				table.insert(args, item.path)

				run_git(args, current_root, function()
					vim.notify("Deleted worktree: " .. item.path, vim.log.levels.INFO)
				end)
			end)
		end)
	end)
end

function M.pick_worktrees()
	local snacks = get_snacks()
	if snacks == nil then
		return
	end

	local items = worktree_items()
	if #items == 0 then
		vim.notify("No git worktrees found", vim.log.levels.INFO)
		return
	end

	local source_ctx = current_source_context()
	snacks.picker.select(items, {
		prompt = "Git Worktrees",
		format_item = format_worktree_item,
	}, function(item)
		if item ~= nil and item.path ~= nil then
			switch_to_worktree(item.path, source_ctx)
		end
	end)
end

function M.create_worktree()
	create_worktree(current_source_context())
end

function M.delete_worktree()
	local current_root = current_worktree_root()
	if current_root == nil then
		vim.notify("Failed to detect current git worktree", vim.log.levels.ERROR)
		return
	end

	local items = worktree_items()
	if #items == 0 then
		vim.notify("No git worktrees found", vim.log.levels.INFO)
		return
	end

	delete_worktree(items, current_root)
end

return M
