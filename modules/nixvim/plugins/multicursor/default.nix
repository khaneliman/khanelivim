{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.multicursor.enable = lib.mkEnableOption "multicursor" // {
    default = true;
  };

  config =
    let
      luaConfig = /* Lua */ ''
        local mc = require('multicursor-nvim')
        mc.setup()

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)
            -- Select a different cursor as the main one.
            layerSet({"n", "x"}, "<left>", mc.prevCursor)
            layerSet({"n", "x"}, "<right>", mc.nextCursor)

            -- Delete the main cursor.
            layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { reverse = true })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorMatchPreview", { link = "Search" })
        hl(0, "MultiCursorDisabledCursor", { reverse = true })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
      '';
    in
    lib.mkIf config.plugins.multicursor.enable {
      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.multicursor-nvim;
          optional = true;
        }
      ];

      plugins.lz-n.plugins = [
        {
          __unkeyed-1 = "multicursor.nvim";
          keys = [
            {
              __unkeyed-1 = "<leader>m";
              mode = [
                "n"
                "x"
              ];
            }
            {
              __unkeyed-1 = "<c-leftmouse>";
              mode = "n";
            }
          ];
          after.__raw = ''
            function()
              ${luaConfig}
            end
          '';
        }
      ];

      plugins.which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>m";
          group = "Multicursor";
          icon = "󰗧";
          mode = [
            "n"
            "x"
          ];
        }
      ];

      keymaps = [
        # Add or skip cursor above/below the main cursor
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>ma";
          action.__raw = "function() require('multicursor-nvim').lineAddCursor(-1) end";
          options.desc = "Add cursor above";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mb";
          action.__raw = "function() require('multicursor-nvim').lineAddCursor(1) end";
          options.desc = "Add cursor below";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mA";
          action.__raw = "function() require('multicursor-nvim').lineSkipCursor(-1) end";
          options.desc = "Skip cursor above";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mB";
          action.__raw = "function() require('multicursor-nvim').lineSkipCursor(1) end";
          options.desc = "Skip cursor below";
        }

        # Add or skip adding a new cursor by matching word/selection
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mn";
          action.__raw = "function() require('multicursor-nvim').matchAddCursor(1) end";
          options.desc = "Add cursor by match (next)";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>ms";
          action.__raw = "function() require('multicursor-nvim').matchSkipCursor(1) end";
          options.desc = "Skip cursor by match (next)";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mp";
          action.__raw = "function() require('multicursor-nvim').matchAddCursor(-1) end";
          options.desc = "Add cursor by match (prev)";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mS";
          action.__raw = "function() require('multicursor-nvim').matchSkipCursor(-1) end";
          options.desc = "Skip cursor by match (prev)";
        }

        # Mouse support
        {
          mode = "n";
          key = "<c-leftmouse>";
          action.__raw = "function() require('multicursor-nvim').handleMouse() end";
          options.desc = "Add cursor with mouse";
        }
        {
          mode = "n";
          key = "<c-leftdrag>";
          action.__raw = "function() require('multicursor-nvim').handleMouseDrag() end";
          options.desc = "Drag cursor with mouse";
        }
        {
          mode = "n";
          key = "<c-leftrelease>";
          action.__raw = "function() require('multicursor-nvim').handleMouseRelease() end";
          options.desc = "Release mouse cursor";
        }

        # Toggle cursors
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>mt";
          action.__raw = "function() require('multicursor-nvim').toggleCursor() end";
          options.desc = "Toggle cursor";
        }
      ];
    };
}
