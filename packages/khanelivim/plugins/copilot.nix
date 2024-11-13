{ config, lib, ... }:
{
  plugins = {
    copilot-lua = {
      enable = true;
      panel.enabled = false;
      suggestion.enabled = false;
    };

    copilot-chat = {
      enable = true;

      settings = {
        window = {
          layout = "float";
          relative = "cursor";
          width = 1;
          height = 0.5;
          row = 1;
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.copilot-chat.enable [
      {
        __unkeyed = "<leader>a";
        group = "Copilot";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.copilot-lua.enable [
    {
      mode = "n";
      key = "<leader>ac";
      action = "<cmd>CopilotChat<CR>";
      options = {
        desc = "Copilot Chat";
      };
    }
  ];
}
