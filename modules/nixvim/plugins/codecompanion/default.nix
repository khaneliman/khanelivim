{
  config,
  lib,
  ...
}:
{
  plugins = {
    codecompanion = {
      # codecompanion.nvim documentation
      # See: https://github.com/olimorris/codecompanion.nvim
      enable = builtins.elem "codecompanion" config.khanelivim.ai.plugins;

      lazyLoad.settings = {
        cmd = [
          "CodeCompanion"
          "CodeCompanionChat"
          "CodeCompanionActions"
          "CodeCompanionAdd"
        ];
      };

      settings = {
        strategies = {
          chat = {
            adapter = "gemini_cli";
          };
          inline = {
            adapter = "gemini_cli";
          };
          cmd = {
            adapter = "gemini_cli";
          };
        };

        adapters.http.local_llm.__raw = ''
          function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              name = 'local_llm',
              formatted_name = 'Local',
              env = {
                -- The server needs no credential, but the adapter sends the
                -- header regardless.
                api_key = 'local',
                url = '${lib.removeSuffix "/v1" config.khanelivim.ai.localEndpoint}',
                chat_url = '/v1/chat/completions',
                models_endpoint = '/v1/models',
              },
            })
          end
        '';

        opts = {
          send_code = true;
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.codecompanion.enable [
      {
        __unkeyed-1 = "<leader>ai";
        group = "CodeCompanion";
        icon = "";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.codecompanion.enable [
    {
      mode = "n";
      key = "<leader>ait";
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      options = {
        desc = "Toggle Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>aic";
      action = "<cmd>CodeCompanionChat<CR>";
      options = {
        desc = "New Chat";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>aia";
      action = "<cmd>CodeCompanionActions<CR>";
      options = {
        desc = "Actions";
      };
    }
    {
      mode = "v";
      key = "<leader>aie";
      action = "<cmd>CodeCompanion<CR>";
      options = {
        desc = "Inline Edit";
      };
    }
    {
      mode = "n";
      key = "<leader>aiq";
      action = "<cmd>CodeCompanion /commit<CR>";
      options = {
        desc = "Quick Commit Message";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>air";
      action = "<cmd>CodeCompanionAdd<CR>";
      options = {
        desc = "Add to Chat";
      };
    }
  ];
}
