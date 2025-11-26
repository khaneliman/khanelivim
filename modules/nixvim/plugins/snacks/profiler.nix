{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraConfigLuaPre =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "profiler" config.plugins.snacks.settings
        && config.plugins.snacks.settings.profiler.enabled
      )
      (
        # NOTE: Allows profiling
        # `PROF=1 nvim` - profiles to UIEnter (default)
        # `PROF=1 PROF_EVENT=deferred nvim` - profiles to DeferredUIEnter (lz.n lazy loads)
        # `PROF=1 PROF_EVENT=lazy nvim` - profiles to VeryLazy
        lib.mkOrder 1 # Lua
          ''
            if vim.env.PROF then
              local snacks = "${pkgs.vimPlugins.snacks-nvim}"
              vim.opt.rtp:append(snacks)

              local event = "UIEnter"
              local pattern = nil

              if vim.env.PROF_EVENT == "deferred" then
                event = "User"
                pattern = "DeferredUIEnter"
              elseif vim.env.PROF_EVENT == "lazy" then
                event = "User"
                pattern = "VeryLazy"
              end

              require("snacks.profiler").startup({
                startup = {
                  event = event,
                  pattern = pattern,
                },
              })
            end
          ''

      );

  extraConfigLua =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "profiler" config.plugins.snacks.settings
        && config.plugins.snacks.settings.profiler.enabled
      )
      # Lua
      ''
        -- Track startup time for profiling
        vim.g._profiler_start_time = vim.loop.hrtime()

        -- Extract plugin name from trace name (handles nix store paths)
        local function get_plugin_name(trace)
          -- If snacks detected a plugin and it's not a nix store hash, use it
          if trace.plugin and not trace.plugin:match("^%w+%-vimplugin") then
            return trace.plugin
          end

          local name = trace.name or ""

          -- Autocmds and vim internals are "core"
          if name:match("^autocmd:") or name:match("^vim%.") then
            return "core"
          end

          -- Extract first component from dotted name (e.g., "snacks.dashboard.setup" -> "snacks")
          local plugin = name:match("^([%w_%-]+)[%._]")
          if plugin then
            -- Handle special cases like "lualine_require" -> "lualine"
            plugin = plugin:gsub("_require$", "")
            -- Handle "lz.n" style names
            if plugin == "lz" and name:match("^lz%.n") then
              return "lz.n"
            end
            return plugin
          end

          return trace.plugin or "core"
        end

        -- Build profiler data structure for export
        local function build_profiler_data(traces, opts)
          opts = opts or {}

          -- Calculate total time from traces
          local total_time = 0
          for _, trace in ipairs(traces) do
            total_time = total_time + (trace.time or 0)
          end

          -- Group by plugin
          local by_plugin = {}
          for _, trace in ipairs(traces) do
            local plugin = get_plugin_name(trace)
            by_plugin[plugin] = by_plugin[plugin] or { time_ns = 0, count = 0 }
            by_plugin[plugin].time_ns = by_plugin[plugin].time_ns + (trace.time or 0)
            by_plugin[plugin].count = by_plugin[plugin].count + (trace.count or 1)
          end

          -- Convert to sorted list
          local plugins_list = {}
          for name, data in pairs(by_plugin) do
            table.insert(plugins_list, {
              name = name,
              time_ms = data.time_ns / 1e6,
              count = data.count,
            })
          end
          table.sort(plugins_list, function(a, b) return a.time_ms > b.time_ms end)

          -- Build traces list (top N by time)
          table.sort(traces, function(a, b) return (a.time or 0) > (b.time or 0) end)
          local traces_list = {}
          local limit = opts.limit or 100
          for i, trace in ipairs(traces) do
            if i > limit then break end
            local loc = ""
            if trace.def then
              loc = string.format("%s:%d", trace.def.file or "?", trace.def.line or 0)
              loc = loc:gsub(vim.fn.expand("$HOME"), "~")
            end
            table.insert(traces_list, {
              name = trace.name or "unknown",
              time_ms = (trace.time or 0) / 1e6,
              count = trace.count or 1,
              plugin = get_plugin_name(trace),
              location = loc,
            })
          end

          -- Calculate startup time if available
          local startup_time_ms = nil
          if vim.g._profiler_start_time then
            startup_time_ms = (vim.loop.hrtime() - vim.g._profiler_start_time) / 1e6
          end

          return {
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            event = vim.env.PROF_EVENT or "UIEnter",
            startup_time_ms = startup_time_ms,
            total_trace_time_ms = total_time / 1e6,
            trace_count = #traces,
            traces = traces_list,
            by_plugin = plugins_list,
          }
        end

        -- Export to JSON format
        local function export_json(data, path)
          -- Simple JSON encoder (no external deps)
          local function encode_value(val)
            if val == nil then return "null" end
            if type(val) == "boolean" then return val and "true" or "false" end
            if type(val) == "number" then return string.format("%.6f", val) end
            if type(val) == "string" then
              return '"' .. val:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n') .. '"'
            end
            if type(val) == "table" then
              if #val > 0 then
                -- Array
                local items = {}
                for _, v in ipairs(val) do
                  table.insert(items, encode_value(v))
                end
                return "[" .. table.concat(items, ",") .. "]"
              else
                -- Object
                local items = {}
                for k, v in pairs(val) do
                  table.insert(items, '"' .. k .. '":' .. encode_value(v))
                end
                return "{" .. table.concat(items, ",") .. "}"
              end
            end
            return "null"
          end

          local json = encode_value(data)
          local file = io.open(path, "w")
          if file then
            file:write(json)
            file:close()
            return true
          end
          return false
        end

        -- Export to Markdown format
        local function export_markdown(data, path)
          local lines = {
            "# Neovim Profiler Report",
            "",
            ("Generated: %s"):format(data.timestamp),
            ("Event: %s"):format(data.event),
          }

          if data.startup_time_ms then
            table.insert(lines, ("Startup time: %.2f ms"):format(data.startup_time_ms))
          end
          table.insert(lines, ("Total trace time: %.2f ms"):format(data.total_trace_time_ms))
          table.insert(lines, ("Total traces: %d"):format(data.trace_count))
          table.insert(lines, "")
          table.insert(lines, "## Top Functions by Time")
          table.insert(lines, "")
          table.insert(lines, "| Time (ms) | Count | Name | Location |")
          table.insert(lines, "|-----------|-------|------|----------|")

          for _, trace in ipairs(data.traces) do
            table.insert(lines, ("| %.3f | %d | `%s` | %s |"):format(
              trace.time_ms, trace.count, trace.name, trace.location
            ))
          end

          table.insert(lines, "")
          table.insert(lines, "## Summary by Plugin")
          table.insert(lines, "")
          table.insert(lines, "| Time (ms) | Calls | Plugin |")
          table.insert(lines, "|-----------|-------|--------|")

          for _, p in ipairs(data.by_plugin) do
            table.insert(lines, ("| %.3f | %d | %s |"):format(p.time_ms, p.count, p.name))
          end

          local content = table.concat(lines, "\n")
          local file = io.open(path, "w")
          if file then
            file:write(content)
            file:close()
            return true
          end
          return false
        end

        -- Main export function
        local function profiler_export(opts)
          opts = opts or {}
          local tracer = require("snacks.profiler.tracer")
          -- Must load traces from core events before finding
          tracer.load()
          local traces, _, _ = tracer.find(opts.filter or {})

          if #traces == 0 then
            vim.notify("No profiler data to export", vim.log.levels.WARN)
            return nil
          end

          local data = build_profiler_data(traces, opts)
          local format = opts.format or "md"

          if opts.file then
            local path = opts.file
            if path == true then
              local ext = format == "json" and ".json" or ".md"
              path = vim.fn.expand("~/nvim-profile-" .. os.date("%Y%m%d-%H%M%S") .. ext)
            end

            local success = false
            if format == "json" then
              success = export_json(data, path)
            elseif format == "both" then
              local json_path = path:gsub("%.md$", ".json")
              local md_path = path:gsub("%.json$", ".md")
              if json_path == md_path then
                json_path = path .. ".json"
                md_path = path .. ".md"
              end
              success = export_json(data, json_path) and export_markdown(data, md_path)
              if success then
                vim.notify("Profiler reports saved to:\n  " .. json_path .. "\n  " .. md_path, vim.log.levels.INFO)
                return data
              end
            else
              success = export_markdown(data, path)
            end

            if success then
              vim.notify("Profiler report saved to: " .. path, vim.log.levels.INFO)
            else
              vim.notify("Failed to write: " .. path, vim.log.levels.ERROR)
            end
          else
            -- Open in scratch buffer (markdown only)
            local lines = {}
            table.insert(lines, "# Neovim Profiler Report")
            table.insert(lines, "")
            table.insert(lines, ("Generated: %s"):format(data.timestamp))
            if data.startup_time_ms then
              table.insert(lines, ("Startup time: %.2f ms"):format(data.startup_time_ms))
            end
            table.insert(lines, ("Total traces: %d"):format(data.trace_count))
            table.insert(lines, "")
            table.insert(lines, "## Top Functions by Time")
            table.insert(lines, "")
            table.insert(lines, "| Time (ms) | Count | Name | Location |")
            table.insert(lines, "|-----------|-------|------|----------|")
            for _, trace in ipairs(data.traces) do
              table.insert(lines, ("| %.3f | %d | `%s` | %s |"):format(
                trace.time_ms, trace.count, trace.name, trace.location
              ))
            end
            table.insert(lines, "")
            table.insert(lines, "## Summary by Plugin")
            table.insert(lines, "")
            table.insert(lines, "| Time (ms) | Calls | Plugin |")
            table.insert(lines, "|-----------|-------|--------|")
            for _, p in ipairs(data.by_plugin) do
              table.insert(lines, ("| %.3f | %d | %s |"):format(p.time_ms, p.count, p.name))
            end
            Snacks.scratch({
              ft = "markdown",
              name = "Profiler Report",
              content = table.concat(lines, "\n"),
            })
          end

          return data
        end

        -- Make export function globally accessible for automation
        _G.profiler_export = profiler_export

        -- Create user command for export
        -- Usage: :ProfilerExport [path]       - export to file or scratch buffer
        --        :ProfilerExport!             - auto-generate filename
        --        :ProfilerExportJson [path]   - export as JSON
        --        :ProfilerExportJson!         - auto-generate JSON filename
        vim.api.nvim_create_user_command("ProfilerExport", function(cmd_opts)
          local opts = { limit = 100, format = "md" }
          if cmd_opts.args ~= "" then
            opts.file = cmd_opts.args
          end
          if cmd_opts.bang then
            opts.file = true
          end
          profiler_export(opts)
        end, {
          nargs = "?",
          bang = true,
          complete = "file",
          desc = "Export profiler results as Markdown (! for auto-filename)",
        })

        vim.api.nvim_create_user_command("ProfilerExportJson", function(cmd_opts)
          local opts = { limit = 100, format = "json" }
          if cmd_opts.args ~= "" then
            opts.file = cmd_opts.args
          end
          if cmd_opts.bang then
            opts.file = true
          end
          profiler_export(opts)
        end, {
          nargs = "?",
          bang = true,
          complete = "file",
          desc = "Export profiler results as JSON (! for auto-filename)",
        })

        -- Auto-export when PROF_OUTPUT is set (for automation)
        -- PROF_OUTPUT: path to output file
        -- PROF_FORMAT: md, json, or both (default: json)
        -- PROF_AUTO_QUIT: if set, quit nvim after export
        if vim.env.PROF and vim.env.PROF_OUTPUT then
          local function auto_export()
            vim.schedule(function()
              -- Prevent double export
              if vim.g._profiler_auto_exported then return end
              vim.g._profiler_auto_exported = true

              local format = vim.env.PROF_FORMAT or "json"
              local output = vim.env.PROF_OUTPUT
              profiler_export({
                file = output,
                format = format,
                limit = 200,
              })
              if vim.env.PROF_AUTO_QUIT then
                vim.cmd("qa!")
              end
            end)
          end

          -- Hook to the profiling end event
          -- Note: UIEnter doesn't fire in headless mode, so we use VimEnter
          -- with a delay to allow plugins to load
          local event = vim.env.PROF_EVENT
          if event == "deferred" then
            -- For deferred, wait for DeferredUIEnter (lz.n lazy loads)
            -- Fall back to timer if in headless mode
            vim.api.nvim_create_autocmd("User", {
              pattern = "DeferredUIEnter",
              once = true,
              callback = auto_export,
            })
            -- Fallback timer for headless mode (DeferredUIEnter won't fire)
            if vim.fn.has("gui_running") == 0 and vim.fn.has("nvim") == 1 then
              vim.defer_fn(function()
                -- Only run if DeferredUIEnter hasn't fired yet
                if vim.g._profiler_auto_exported then return end
                vim.g._profiler_auto_exported = true
                auto_export()
              end, 3000) -- 3 second fallback for headless
            end
          elseif event == "lazy" then
            vim.api.nvim_create_autocmd("User", {
              pattern = "VeryLazy",
              once = true,
              callback = auto_export,
            })
          else
            -- Default: use VimEnter with a small delay (works in headless)
            vim.api.nvim_create_autocmd("VimEnter", {
              once = true,
              callback = function()
                -- Small delay to ensure profiler has captured startup
                vim.defer_fn(auto_export, 100)
              end,
            })
          end
        end
      '';

  plugins = {
    snacks = {
      settings = {
        profiler.enabled = true;
      };
    };
  };
}
