{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        rename.enabled = true;
      };
    };
  };

  # Integration with file explorers
  autoGroups = {
    snacks_rename_integration = {
      clear = true;
    };
  };

  autoCmd =
    lib.optionals
      (
        config.plugins.snacks.enable
        && lib.hasAttr "rename" config.plugins.snacks.settings
        && config.plugins.snacks.settings.rename.enabled
      )

      [
        # mini.files integration
        (lib.mkIf (config.plugins.mini.enable && lib.hasAttr "files" config.plugins.mini.modules) {
          event = "User";
          pattern = "MiniFilesActionRename";
          group = "snacks_rename_integration";
          callback.__raw = ''
            function(event)
              Snacks.rename.on_rename_file(event.data.from, event.data.to)
            end
          '';
        })

        # neo-tree integration
        (lib.mkIf config.plugins.neo-tree.enable {
          event = "User";
          pattern = "NeoTreeSetup";
          group = "snacks_rename_integration";
          callback.__raw = ''
            function()
              local events = require("neo-tree.events")
              local handler = function(data)
                Snacks.rename.on_rename_file(data.source, data.destination)
              end

              require("neo-tree").config.event_handlers = require("neo-tree").config.event_handlers or {}
              vim.list_extend(require("neo-tree").config.event_handlers, {
                { event = events.FILE_MOVED, handler = handler },
                { event = events.FILE_RENAMED, handler = handler },
              })
            end
          '';
        })
      ];

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "rename" config.plugins.snacks.settings
        && config.plugins.snacks.settings.rename.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>cr";
          action = "<cmd>lua Snacks.rename.rename_file()<CR>";
          options = {
            desc = "Rename File";
          };
        }
      ];
}
