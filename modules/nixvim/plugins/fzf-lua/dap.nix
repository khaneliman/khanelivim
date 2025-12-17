{ lib, config, ... }:
{
  keymaps = lib.mkIf (config.plugins.fzf-lua.enable && config.plugins.dap.enable) [
    {
      mode = "n";
      key = "<leader>dB";
      action = "<cmd>FzfLua dap_breakpoints<CR>";
      options = {
        desc = "Find dap breakpoints";
      };
    }
    {
      mode = "n";
      key = "<leader>dC";
      action = "<cmd>FzfLua dap_commands<CR>";
      options = {
        desc = "Find dap commands";
      };
    }
    {
      mode = "n";
      key = "<leader>df";
      action = "<cmd>FzfLua dap_frames<CR>";
      options = {
        desc = "Find dap frames";
      };
    }
    {
      mode = "n";
      key = "<leader>dv";
      action = "<cmd>FzfLua dap_variables<CR>";
      options = {
        desc = "Find dap variables";
      };
    }
  ];
}
