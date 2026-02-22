{
  config,
  lib,
  ...
}:
{
  extraConfigLuaPre =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "debug" config.plugins.snacks.settings
        && config.plugins.snacks.settings.debug.enabled
      )
      /* Lua */ ''
        -- Global debug utilities
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override vim.print for quick debugging
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = dd
        end
      '';

  plugins = {
    snacks = {
      settings = {
        debug.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "debug" config.plugins.snacks.settings
        && config.plugins.snacks.settings.debug.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>dX";
          action = "<cmd>lua Snacks.debug.run()<CR>";
          options = {
            desc = "Run Buffer";
          };
        }
        {
          mode = "x";
          key = "<leader>dX";
          action = "<cmd>lua Snacks.debug.run()<CR>";
          options = {
            desc = "Run Selection";
          };
        }
        {
          mode = "n";
          key = "<leader>dS";
          action = "<cmd>lua Snacks.debug.stats()<CR>";
          options = {
            desc = "Show Debug Stats";
          };
        }
        {
          mode = "n";
          key = "<leader>dT";
          action.__raw = ''
            function()
              if vim.g.snacks_debug_trace_enabled == nil then
                vim.g.snacks_debug_trace_enabled = false
              end

              vim.g.snacks_debug_trace_enabled = not vim.g.snacks_debug_trace_enabled

              if vim.g.snacks_debug_trace_enabled then
                Snacks.debug.trace()
                vim.notify("Debug trace started", vim.log.levels.INFO)
              else
                Snacks.debug.trace()
                vim.notify("Debug trace stopped", vim.log.levels.INFO)
              end
            end
          '';
          options = {
            desc = "Toggle Debug Trace";
          };
        }
        {
          mode = "n";
          key = "<leader>dP";
          action.__raw = ''
            function()
              vim.ui.input({ prompt = "Profile iterations (default 100): " }, function(input)
                local count = tonumber(input) or 100
                local current_line = vim.api.nvim_get_current_line()
                local fn = loadstring("return " .. current_line)
                if fn then
                  Snacks.debug.profile(fn(), { count = count, title = "Profile: " .. current_line:sub(1, 50) })
                else
                  vim.notify("Could not load current line as function", vim.log.levels.ERROR)
                end
              end)
            end
          '';
          options = {
            desc = "Profile Current Line";
          };
        }
      ];
}
