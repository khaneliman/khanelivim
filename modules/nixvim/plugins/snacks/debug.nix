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
}
