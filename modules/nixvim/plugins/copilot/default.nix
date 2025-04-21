{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./migrateNixvimPlugin.nix
    ./migrateNixvimTests.nix
  ];

  extraPlugins = lib.optionals (config.plugins.copilot-lua.enable && config.plugins.lualine.enable) (
    with pkgs.vimPlugins;
    [
      copilot-lualine
    ]
  );

  plugins = {
    copilot-lua = {
      enable = true;

      lazyLoad.settings.event = [ "InsertEnter" ];

      settings = {
        panel.enabled = !config.plugins.blink-cmp-copilot.enable;
        suggestion.enabled = !config.plugins.blink-cmp-copilot.enable;
        lsp_binary = lib.getExe pkgs.copilot-language-server;
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
        __unkeyed-1 = "<leader>aC";
        group = "Copilot";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.copilot-chat.enable [
    {
      mode = "n";
      key = "<leader>aCc";
      action = "<cmd>CopilotChat<CR>";
      options = {
        desc = "Open Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>aCq";
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
      key = "<leader>aCh";
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
      key = "<leader>aCp";
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
      key = "<leader>aCa";
      action = "<cmd>CopilotChatAgents<CR>";
      options = {
        desc = "List Available Agents";
      };
    }
    {
      mode = "n";
      key = "<leader>aCl";
      action = "<cmd>CopilotChatLoad<CR>";
      options = {
        desc = "Load Chat History";
      };
    }
    {
      mode = "n";
      key = "<leader>aCm";
      action = "<cmd>CopilotChatModels<CR>";
      options = {
        desc = "List Available Models";
      };
    }
    {
      mode = "n";
      key = "<leader>aCo";
      action = "<cmd>CopilotChatOpen<CR>";
      options = {
        desc = "Open Chat Window";
      };
    }
    {
      mode = "n";
      key = "<leader>aCt";
      action = "<cmd>CopilotChatToggle<CR>";
      options = {
        desc = "Toggle Chat Window";
      };
    }
  ];
}
