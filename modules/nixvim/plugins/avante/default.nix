{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    avante = {
      # avante.nvim documentation
      # See: https://github.com/yetone/avante.nvim
      enable = builtins.elem "avante" config.khanelivim.ai.plugins;

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        provider = "codex";
        providers = {
          claude = {
            model = "claude-sonnet-4-6";
          };

          # Selectable rather than default, and reachable through the shared
          # endpoint option so a move needs no edit here.
          local_llm = {
            __inherited_from = "openai";
            endpoint = config.khanelivim.ai.localEndpoint;
            # The server needs no credential, but avante reads one.
            api_key_name = "";
            model = "qwen3-coder-30b";
          };
        };
        acp_providers = {
          # An ACP bridge ships as its own binary, so name the store path rather
          # than trusting PATH inside the editor.
          codex = {
            command = lib.getExe pkgs.codex-acp;
            # The bridge embeds an older codex core, and the API rejects a newer
            # model slug for it: gpt-5.6-sol returns 400 asking for a newer
            # client. gpt-5.5 completes a turn.
            args = [
              "-c"
              "model=\"gpt-5.5\""
            ];
            # No credential here: the bridge reads the signed-in session from
            # CODEX_HOME, and this user holds ChatGPT tokens rather than an API
            # key.
            env = { };
          };

          claude-code = {
            model = "claude-sonnet-4-6";
            env = {
              ANTHROPIC_API_KEY.__raw = ''os.getenv("ANTHROPIC_API_KEY")'';
            };
          };
          gemini-cli = {
            model = "gemini-3.1-pro-preview";
            env = {
              GEMINI_API_KEY.__raw = ''os.getenv("GEMINI_API_KEY")'';
            };
          };
        };
        # Define our own mappings under correct prefix
        mappings = {
          ask = "<leader>aaa";
          new_ask = "<leader>aan";
          edit = "<leader>aae";
          refresh = "<leader>aar";
          focus = "<leader>aaf";
          stop = "<leader>aaS";
          toggle = {
            default = "<leader>aat";
            debug = "<leader>aad";
            hint = "<leader>aah";
            selection = "<leader>aaC";
            suggestion = "<leader>aas";
            repomap = "<leader>aaR";
          };
          files = {
            add_current = "<leader>aa.";
            add_all_buffers = "<leader>aaB";
          };
          select_model = "<leader>aa?";
          select_history = "<leader>aah";
          zen_mode = "<leader>aaz";
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>aa";
        group = "Avante";
        icon = "";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };

  keymaps = lib.optionals config.plugins.avante.enable [
    {
      mode = "n";
      key = "<leader>aac";
      action = "<CMD>AvanteClear<CR>";
      options.desc = "avante: clear";
    }
  ];
}
