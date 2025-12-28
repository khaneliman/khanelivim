{ config, lib, ... }:
{
  plugins.inc-rename = {
    enable = config.khanelivim.editor.rename == "inc-rename";

    lazyLoad.settings = {
      event = [
        "DeferredUIEnter"
      ];
    };

    settings = {
      cmd_name = "IncRename";
      hl_group = "Substitute";
      preview_empty_name = false;
      show_message = true;
      save_in_cmdline_history = true;
      # NOTE: Shows at top like a regular command
      # Enabled in noice with inline style hover
      input_buffer_type = lib.mkIf (!config.plugins.noice.enable) { __raw = ''"snacks"''; };
    };
  };

  keymaps = lib.optionals config.plugins.inc-rename.enable [
    {
      mode = "n";
      key = "gR";
      action.__raw = ''
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end
      '';
      options = {
        expr = true;
        desc = "Start IncRename";
      };
    }
  ];
}
