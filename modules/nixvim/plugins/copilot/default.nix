{ config, lib, ... }:
{
  imports = [ ./migrateNixvimPlugin.nix ];

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

      lazyLoad.settings.cmd = [
        "CopilotChat"
        "CopilotChatAgents"
        "CopilotChatLoad"
        "CopilotChatModels"
        "CopilotChatOpen"
        "CopilotChatToggle"
      ];

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
        __unkeyed-1 = "<leader>c";
        group = "Copilot";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.copilot-chat.enable [
    {
      mode = "n";
      key = "<leader>cc";
      action = "<cmd>CopilotChat<CR>";
      options = {
        desc = "Open Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>cq";
      action.__raw = ''
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end
      '';
      options = {
        desc = "Quick Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>ch";
      action.__raw = ''
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end
      '';
      options = {
        desc = "Help Actions";
      };
    }
    {
      mode = "n";
      key = "<leader>cp";
      action.__raw = ''
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end
      '';
      options = {
        desc = "Prompt Actions";
      };
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>CopilotChatAgents<CR>";
      options = {
        desc = "List Available Agents";
      };
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>CopilotChatLoad<CR>";
      options = {
        desc = "Load Chat History";
      };
    }
    {
      mode = "n";
      key = "<leader>cm";
      action = "<cmd>CopilotChatModels<CR>";
      options = {
        desc = "List Available Models";
      };
    }
    {
      mode = "n";
      key = "<leader>co";
      action = "<cmd>CopilotChatOpen<CR>";
      options = {
        desc = "Open Chat Window";
      };
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>CopilotChatToggle<CR>";
      options = {
        desc = "Toggle Chat Window";
      };
    }
  ];
}
