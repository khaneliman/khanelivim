{
  config,
  lib,
  pkgs,
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
            adapter = "codex";
          };
          inline = {
            adapter = "codex";
          };
          cmd = {
            adapter = "codex";
          };
        };

        # The ACP bridge ships as its own binary, so name the store path rather
        # than trusting PATH inside the editor.
        adapters.acp.codex.__raw = ''
          function()
            return require('codecompanion.adapters').extend('codex', {
              commands = {
                -- The bridge embeds an older codex core, and the API rejects a
                -- newer model slug for it: gpt-5.6-sol returns 400 asking for a
                -- newer client. gpt-5.5 completes a turn.
                default = {
                  '${lib.getExe pkgs.codex-acp}',
                  '-c', 'model="gpt-5.5"',
                },
              },
              defaults = {
                -- This user signs in through ChatGPT, so the adapter default of
                -- api-key would look for an OPENAI_API_KEY that does not exist.
                -- The bridge reads the session from CODEX_HOME instead.
                auth_method = 'chat-gpt',
              },
            })
          end
        '';

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
