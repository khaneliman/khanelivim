{
  config,
  lib,
  pkgs,
  ...
}:
let
  enabled = builtins.elem "minuet" config.khanelivim.ai.plugins;

  duetEnabled = enabled && config.khanelivim.ai.duetEnable;
in
{
  plugins = {
    minuet = {
      # minuet-ai.nvim documentation
      # See: https://github.com/milanglacier/minuet-ai.nvim
      enable = enabled;

      lazyLoad.settings = {
        event = [ "InsertEnter" ];

        # The toggle command exists only after the plugin loads, so the keymap
        # doubles as a load trigger.
        keys = [
          {
            __unkeyed-1 = "<leader>am";
            __unkeyed-2 = "<cmd>Minuet blink toggle<CR>";
            desc = "Toggle Minuet Auto Completion";
          }
        ]
        ++ lib.optionals duetEnabled [
          {
            __unkeyed-1 = "<leader>anp";
            __unkeyed-2 = "<cmd>Minuet duet predict<CR>";
            desc = "Predict Next Edit";
          }
          {
            __unkeyed-1 = "<leader>ana";
            __unkeyed-2 = "<cmd>Minuet duet apply<CR>";
            desc = "Apply Next Edit";
          }
          {
            __unkeyed-1 = "<leader>and";
            __unkeyed-2 = "<cmd>Minuet duet dismiss<CR>";
            desc = "Dismiss Next Edit";
          }
          {
            __unkeyed-1 = "<A-z>";
            __unkeyed-2 = "<cmd>Minuet duet predict<CR>";
            mode = "i";
            desc = "Predict Next Edit";
          }
          {
            __unkeyed-1 = "<A-a>";
            __unkeyed-2 = "<cmd>Minuet duet apply<CR>";
            mode = "i";
            desc = "Apply Next Edit";
          }
          {
            __unkeyed-1 = "<A-x>";
            __unkeyed-2 = "<cmd>Minuet duet dismiss<CR>";
            mode = "i";
            desc = "Dismiss Next Edit";
          }
        ];
      };

      settings = {
        provider = "openai_fim_compatible";

        # One candidate keeps a local GPU responsive during insert mode.
        n_completions = 1;

        # A small window keeps request latency low. Raise it when the host
        # serves a larger model or has spare VRAM.
        context_window = 1024;

        provider_options.openai_fim_compatible = {
          # Ollama needs no credential, but minuet refuses to send a request
          # without one. Return a constant rather than naming an environment
          # variable, which may be unset.
          api_key.__raw = "function() return 'ollama' end";
          name = "Ollama";

          # The legacy completions endpoint carries the suffix field, so the
          # model receives the text on both sides of the cursor.
          end_point = "http://localhost:11434/v1/completions";

          # Only a base tag completes at the cursor. Its template splits the
          # text before the cursor from the text after it, which the instruct
          # tags do not do.
          model = "qwen2.5-coder:1.5b-base";

          optional = {
            max_tokens = 56;
            top_p = 0.9;
          };
        };

        duet = lib.mkIf duetEnabled {
          provider = "openai_compatible";

          provider_options.openai_compatible = {
            api_key.__raw = "function() return 'ollama' end";
            name = "Ollama";

            # Duet rewrites a whole region, so it posts a chat request rather
            # than a completion request.
            end_point = "http://localhost:11434/v1/chat/completions";

            # An instruct model has to serve the rewrite. This tag activates
            # 3B of its 30B parameters, which keeps a prediction interactive.
            model = "qwen3-coder:30b";
          };

          # The edit recorder shells out to diff. Read it from the store
          # instead of the user's PATH.
          recent_edits.diff_program = lib.getExe' pkgs.diffutils "diff";
        };
      };
    };
  };
}
