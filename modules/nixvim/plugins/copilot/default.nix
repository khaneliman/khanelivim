{ config, lib, ... }:
{
  plugins = {
    copilot-lua = {
      enable = true;

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        panel.enabled = false;
        suggestion.enabled = false;
      };
    };

    copilot-chat = {
      inherit (config.plugins.copilot-lua) enable;

      lazyLoad.settings.cmd = "CopilotChat";

      settings = {
        # NOTE: if you want float
        # window = {
        #   layout = "float";
        #   relative = "cursor";
        #   width = 1;
        #   height = 0.5;
        #   row = 1;
        # };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.copilot-chat.enable [
      {
        __unkeyed-1 = "<leader>a";
        group = "AI";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.copilot-chat.enable [
    {
      mode = "n";
      key = "<leader>aC";
      action = "<cmd>CopilotChat<CR>";
      options = {
        desc = "Copilot Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>aq";
      action.__raw = ''
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end
      '';
      options = {
        desc = "copilot: Quick Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>aH";
      action.__raw = ''
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end
      '';
      options = {
        desc = "copilot: Help Actions";
      };
    }
    {
      mode = "n";
      key = "<leader>ap";
      action.__raw = ''
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end
      '';
      options = {
        desc = "copilot: Prompt Actions";
      };
    }
  ];
}
