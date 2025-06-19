{
  config,
  lib,
  ...
}:
{
  extraConfigLuaPre =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "bufdelete" config.plugins.snacks.settings) # Lua
      ''
        -- Disable built-in diagnostic keymaps that conflict with <C-W> closing a buffer
        vim.keymap.del('n', '<C-W>d')
        vim.keymap.del('n', '<C-W><C-D>')
      '';

  plugins = {
    snacks = {
      enable = true;

      settings = {
        bufdelete.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "bufdelete" config.plugins.snacks.settings
        && config.plugins.snacks.settings.bufdelete.enabled
      )
      [
        {
          mode = "n";
          key = "<C-w>";
          action = ''<cmd>lua Snacks.bufdelete.delete()<cr>'';
          options = {
            desc = "Close buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>bc";
          action = ''<cmd>lua Snacks.bufdelete.other()<cr>'';
          options = {
            desc = "Close all buffers but current";
          };
        }
        {
          mode = "n";
          key = "<leader>bC";
          action = ''<cmd>lua Snacks.bufdelete.all()<cr>'';
          options = {
            desc = "Close all buffers";
          };
        }
      ];
}
