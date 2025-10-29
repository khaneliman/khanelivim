{ config, lib, ... }:
{
  plugins = {
    snacks = {
      settings = {
        terminal.enabled = lib.elem "snacks" config.khanelivim.ui.terminal;
      };
    };
  };

  keymaps = lib.mkIf (lib.elem "snacks" config.khanelivim.ui.terminal) [
    {
      mode = "n";
      key = "<C-/>";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options = {
        desc = "Toggle Terminal";
      };
    }
    {
      mode = "t";
      key = "<C-/>";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options = {
        desc = "Toggle Terminal";
      };
    }
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options = {
        desc = "Toggle Terminal";
      };
    }
  ];
}
