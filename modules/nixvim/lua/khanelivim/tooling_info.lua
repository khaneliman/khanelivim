-- luacheck: globals vim

local M = {}

local web_tools = require("khanelivim.web_tools")

local diagnostic_severity_labels = {
	[vim.diagnostic.severity.ERROR] = "error",
	[vim.diagnostic.severity.WARN] = "warn",
	[vim.diagnostic.severity.INFO] = "info",
	[vim.diagnostic.severity.HINT] = "hint",
}

local function bool_text(value)
	return value and "on" or "off"
end

local function format_virtual_lines(value)
	if value == false or value == nil then
		return "off"
	end

	if type(value) == "table" and value.current_line then
		return "current_line"
	end

	return "on"
end

local function format_jump_severity(value)
	if value == nil then
		return "all"
	end

	if type(value) == "table" and value.min then
		return (diagnostic_severity_labels[value.min] or tostring(value.min)) .. "+"
	end

	if type(value) == "number" then
		return diagnostic_severity_labels[value] or tostring(value)
	end

	return tostring(value)
end

local function unique(list)
	local seen = {}
	local ordered = {}

	for _, item in ipairs(list) do
		if item and item ~= "" and not seen[item] then
			seen[item] = true
			table.insert(ordered, item)
		end
	end

	return ordered
end

local function describe_clients(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local described = {}

	for _, client in ipairs(clients) do
		local supports = function(method)
			return client:supports_method(method)
		end

		table.insert(described, {
			name = client.name,
			root_dir = client.root_dir,
			formatting = supports("textDocument/formatting"),
			range_formatting = supports("textDocument/rangeFormatting"),
			code_lens = supports("textDocument/codeLens"),
			linked_editing = supports("textDocument/linkedEditingRange"),
			semantic_tokens = client.server_capabilities.semanticTokensProvider ~= nil,
			inlay_hints = client.server_capabilities.inlayHintProvider ~= nil,
		})
	end

	return described
end

local function describe_formatters(bufnr)
	local ok, conform = pcall(require, "conform")
	if not ok or type(conform.list_formatters_to_run) ~= "function" then
		return nil
	end

	local formatters, lsp_fallback = conform.list_formatters_to_run(bufnr)

	return {
		names = vim.tbl_map(function(formatter)
			return formatter.name
		end, formatters),
		lsp_fallback = lsp_fallback,
	}
end

function M.describe(bufnr)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

	local buffer_path = vim.api.nvim_buf_get_name(bufnr)
	local clients = describe_clients(bufnr)
	local roots = unique(vim.tbl_map(function(client)
		return client.root_dir
	end, clients))
	local diagnostics = vim.diagnostic.config(nil, bufnr)
	local web = web_tools.describe(bufnr)

	return {
		path = buffer_path ~= "" and buffer_path or nil,
		filetype = vim.bo[bufnr].filetype,
		roots = roots,
		clients = clients,
		diagnostics = {
			enabled = vim.diagnostic.is_enabled({ bufnr = bufnr }),
			update_in_insert = diagnostics.update_in_insert == true,
			virtual_lines = format_virtual_lines(diagnostics.virtual_lines),
			jump_severity = format_jump_severity(diagnostics.jump and diagnostics.jump.severity),
		},
		formatting = describe_formatters(bufnr),
		web = web,
	}
end

function M.notify(bufnr)
	local details = M.describe(bufnr)
	local lines = {
		"Filetype: " .. details.filetype,
		"Path: " .. (details.path or "[No Name]"),
		"Roots: " .. (#details.roots > 0 and table.concat(details.roots, ", ") or "none"),
		string.format(
			"Diagnostics: %s | insert: %s | virtual lines: %s | jump: %s",
			bool_text(details.diagnostics.enabled),
			bool_text(details.diagnostics.update_in_insert),
			details.diagnostics.virtual_lines,
			details.diagnostics.jump_severity
		),
	}

	if #details.clients > 0 then
		table.insert(lines, "LSP Clients:")
		for _, client in ipairs(details.clients) do
			table.insert(
				lines,
				string.format(
					"  - %s [fmt:%s range:%s lens:%s linked:%s sem:%s hints:%s]",
					client.name,
					bool_text(client.formatting),
					bool_text(client.range_formatting),
					bool_text(client.code_lens),
					bool_text(client.linked_editing),
					bool_text(client.semantic_tokens),
					bool_text(client.inlay_hints)
				)
			)
		end
	else
		table.insert(lines, "LSP Clients: none")
	end

	if details.formatting then
		local formatters = #details.formatting.names > 0 and table.concat(details.formatting.names, ", ") or "none"
		local lsp_fallback = details.formatting.lsp_fallback and " | lsp fallback: on" or ""
		table.insert(lines, "Formatters: " .. formatters .. lsp_fallback)
	end

	if details.web.preferred then
		table.insert(lines, "Web Formatter Owner: " .. details.web.preferred.owner)
	end

	if details.web.diagnostics_owner then
		table.insert(lines, "Web Diagnostics Owner: " .. details.web.diagnostics_owner)
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Tooling Info" })
end

return M
